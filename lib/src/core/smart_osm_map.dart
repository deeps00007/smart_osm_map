import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import '../models/internal_map_item.dart';
import '../defaults/default_image_marker.dart';
import '../location/location_service.dart';
import '../layers/user_location_layer.dart';
import '../layers/animated_radius_layer.dart';
import '../utils/distance_utils.dart';

class SmartOsmMap<T> extends StatefulWidget {
  final List<InternalMapItem<T>> _items;
  final String? Function(T)? _markerImage;
  final void Function(T)? _onTap;

  final bool _showUserLocation;
  final bool _enableNearby;
  final double _nearbyRadiusMeters;

  // 🔔 Permission callbacks
  final VoidCallback? _onLocationPermissionGranted;
  final VoidCallback? _onLocationPermissionDenied;
  final VoidCallback? _onLocationPermissionDeniedForever;
  final VoidCallback? _onLocationServiceDisabled;

  final double _markerSize;
  final Color _markerBorderColor;
  final Color _clusterColor;
  final Color _radiusColor;

  const SmartOsmMap._({
    required List<InternalMapItem<T>> items,
    String? Function(T)? markerImage,
    void Function(T)? onTap,
    bool showUserLocation = false,
    bool enableNearby = false,
    double nearbyRadiusMeters = 10000,
    VoidCallback? onLocationPermissionGranted,
    VoidCallback? onLocationPermissionDenied,
    VoidCallback? onLocationPermissionDeniedForever,
    VoidCallback? onLocationServiceDisabled,
    double markerSize = 56,
    Color markerBorderColor = Colors.blue,
    Color clusterColor = Colors.black,
    Color radiusColor = Colors.blue,
    super.key,
  })  : _items = items,
        _markerImage = markerImage,
        _onTap = onTap,
        _showUserLocation = showUserLocation,
        _enableNearby = enableNearby,
        _nearbyRadiusMeters = nearbyRadiusMeters,
        _onLocationPermissionGranted = onLocationPermissionGranted,
        _onLocationPermissionDenied = onLocationPermissionDenied,
        _onLocationPermissionDeniedForever = onLocationPermissionDeniedForever,
        _onLocationServiceDisabled = onLocationServiceDisabled,
        _markerSize = markerSize,
        _markerBorderColor = markerBorderColor,
        _clusterColor = clusterColor,
        _radiusColor = radiusColor;

  factory SmartOsmMap.simple({
    required List<T> items,
    required double Function(T) latitude,
    required double Function(T) longitude,
    String? Function(T)? markerImage,
    void Function(T)? onTap,
    bool showUserLocation = false,
    bool enableNearby = false,
    double nearbyRadiusKm = 10,
    VoidCallback? onLocationPermissionGranted,
    VoidCallback? onLocationPermissionDenied,
    VoidCallback? onLocationPermissionDeniedForever,
    VoidCallback? onLocationServiceDisabled,
    double markerSize = 56,
    Color markerBorderColor = Colors.blue,
    Color clusterColor = Colors.black,
    Color radiusColor = Colors.blue,
  }) {
    return SmartOsmMap._(
      items: items
          .map(
            (e) => InternalMapItem<T>(
              id: e.hashCode.toString(),
              position: LatLng(latitude(e), longitude(e)),
              data: e,
            ),
          )
          .toList(),
      markerImage: markerImage,
      onTap: onTap,
      showUserLocation: showUserLocation,
      enableNearby: enableNearby,
      nearbyRadiusMeters: nearbyRadiusKm * 1000,
      onLocationPermissionGranted: onLocationPermissionGranted,
      onLocationPermissionDenied: onLocationPermissionDenied,
      onLocationPermissionDeniedForever: onLocationPermissionDeniedForever,
      onLocationServiceDisabled: onLocationServiceDisabled,
      markerSize: markerSize,
      markerBorderColor: markerBorderColor,
      clusterColor: clusterColor,
      radiusColor: radiusColor,
    );
  }

  @override
  State<SmartOsmMap<T>> createState() => _SmartOsmMapState<T>();
}

class _SmartOsmMapState<T> extends State<SmartOsmMap<T>>
    with TickerProviderStateMixin {
  final LocationService _locationService = LocationService();
  LatLng? _userLocation;

  late final AnimationController _radiusController;

  @override
  void initState() {
    super.initState();
    _radiusController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
  }

  @override
  void didUpdateWidget(covariant SmartOsmMap<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool locationWasOff =
        !oldWidget._showUserLocation && !oldWidget._enableNearby;
    final bool locationIsOn = widget._showUserLocation || widget._enableNearby;

    if (locationWasOff && locationIsOn) {
      _loadUserLocation();
    }
  }

  Future<void> _loadUserLocation() async {
    final (result, location) =
        await _locationService.getCurrentLocationWithStatus();

    switch (result) {
      case LocationResult.serviceDisabled:
        widget._onLocationServiceDisabled?.call();
        return;

      case LocationResult.permissionDenied:
        widget._onLocationPermissionDenied?.call();
        return;

      case LocationResult.permissionDeniedForever:
        widget._onLocationPermissionDeniedForever?.call();
        return;

      case LocationResult.success:
        widget._onLocationPermissionGranted?.call();
        if (!mounted || location == null) return;
        setState(() => _userLocation = location);
        return;

      case LocationResult.failed:
        return;
    }
  }

  @override
  void dispose() {
    _radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._items.isEmpty) {
      return const Center(child: Text('No map data'));
    }

    final bool effectiveShowLocation =
        widget._showUserLocation || widget._enableNearby;

    final bool canUseNearby = widget._enableNearby && _userLocation != null;

    final visibleItems = canUseNearby
        ? widget._items.where((item) {
            final distance = DistanceUtils.distanceInMeters(
              _userLocation!,
              item.position,
            );
            return distance <= widget._nearbyRadiusMeters;
          }).toList()
        : widget._items;

    final LatLng center = _userLocation ?? widget._items.first.position;

    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: canUseNearby ? 14 : 13,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.smart.osm.map',
            ),
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 45,
                size: const Size(60, 60),
                markers: visibleItems.map((item) {
                  return Marker(
                    point: item.position,
                    width: widget._markerSize,
                    height: widget._markerSize,
                    child: GestureDetector(
                      onTap: () => widget._onTap?.call(item.data),
                      child: DefaultImageMarker(
                        imageUrl: widget._markerImage?.call(item.data),
                        size: widget._markerSize,
                        borderColor: widget._markerBorderColor,
                      ),
                    ),
                  );
                }).toList(),
                builder: (context, markers) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget._clusterColor,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      markers.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (canUseNearby)
              AnimatedRadiusLayer(
                center: _userLocation!,
                animation: _radiusController,
                radiusInMeters: widget._nearbyRadiusMeters,
                color: widget._radiusColor,
              ),
            if (effectiveShowLocation && _userLocation != null)
              UserLocationLayer(location: _userLocation!),
          ],
        ),

        // 🧠 Empty nearby state
        if (widget._enableNearby &&
            _userLocation != null &&
            visibleItems.isEmpty)
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'No places found within this area',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
