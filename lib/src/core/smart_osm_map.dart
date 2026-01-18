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
  final _locationService = LocationService();
  LatLng? _userLocation;

  late final AnimationController _radiusController;

  @override
  void initState() {
    super.initState();
    _radiusController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
  }

  /// 🔥 THIS IS THE KEY FIX
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
    final location = await _locationService.getCurrentLocation();
    if (!mounted || location == null) return;

    setState(() => _userLocation = location);
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

    final bool canUseNearby = widget._enableNearby && _userLocation != null;

    final visibleItems = canUseNearby
        ? widget._items.where((item) {
            final d = DistanceUtils.distanceInMeters(
              _userLocation!,
              item.position,
            );
            return d <= widget._nearbyRadiusMeters;
          }).toList()
        : widget._items;

    final LatLng center = _userLocation ?? widget._items.first.position;

    return FlutterMap(
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
        if (_userLocation != null) UserLocationLayer(location: _userLocation!),
      ],
    );
  }
}
