import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart' hide Path;

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
  // final Color _clusterColor;
  final Color _radiusColor;
  final double _minZoom;
  final double _maxZoom;
  final double _initialZoom;
  final LatLng? _initialCenter;
  final VoidCallback? _onMapReady;
  final bool _useClustering;
  final Widget Function(BuildContext, List<Marker>)? _clusterBuilder;

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
    double minZoom = 2.0,
    double maxZoom = 18.0,
    double initialZoom = 13.0,
    LatLng? initialCenter,
    VoidCallback? onMapReady,
    bool useClustering = true,
    Widget Function(BuildContext, List<Marker>)? clusterBuilder,
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
        // _clusterColor = clusterColor,
        _radiusColor = radiusColor,
        _minZoom = minZoom,
        _maxZoom = maxZoom,
        _initialZoom = initialZoom,
        _initialCenter = initialCenter,
        _onMapReady = onMapReady,
        _useClustering = useClustering,
        _clusterBuilder = clusterBuilder;

  factory SmartOsmMap.simple({
    required List<T> items,
    required double? Function(T) latitude,
    required double? Function(T) longitude,
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
    double minZoom = 2.0,
    double maxZoom = 18.0,
    double initialZoom = 13.0,
    LatLng? initialCenter,
    VoidCallback? onMapReady,
    bool useClustering = true,
    Widget Function(BuildContext, List<Marker>)? clusterBuilder,
  }) {
    return SmartOsmMap._(
      items: items
          .map((e) {
            final lat = latitude(e);
            final lng = longitude(e);
            if (lat == null || lng == null) return null;
            return InternalMapItem<T>(
              id: e.hashCode.toString(),
              position: LatLng(lat, lng),
              data: e,
            );
          })
          .whereType<InternalMapItem<T>>()
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
      minZoom: minZoom,
      maxZoom: maxZoom,
      initialZoom: initialZoom,
      initialCenter: initialCenter,
      onMapReady: onMapReady,
      useClustering: useClustering,
      clusterBuilder: clusterBuilder,
    );
  }

  @override
  State<SmartOsmMap<T>> createState() => _SmartOsmMapState<T>();
}

class _SmartOsmMapState<T> extends State<SmartOsmMap<T>>
    with TickerProviderStateMixin {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  LocationResult? _locationResult;

  late final AnimationController _radiusController;
  late final AnimationController _moveController;

  @override
  void initState() {
    super.initState();
    _radiusController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
    _moveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
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

    if (!mounted) return;
    setState(() => _locationResult = result);

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
        _animatedMapMove(location, 15);
        return;

      case LocationResult.failed:
        return;
    }
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some variables that hold the current state of the map
    final latTween = Tween<double>(
      begin: _mapController.camera.center.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: _mapController.camera.center.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(
      begin: _mapController.camera.zoom,
      end: destZoom,
    );

    final controller = _moveController;
    controller.reset();

    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );

    controller.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    controller.forward();
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _moveController.dispose();
    _mapController.dispose();
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

    final LatLng center = widget._items.first.position;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: widget._initialCenter ?? center,
            initialZoom: widget._initialZoom,
            minZoom: widget._minZoom,
            maxZoom: widget._maxZoom,
            onMapReady: widget._onMapReady,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.smart.osm.map',
            ),
            if (canUseNearby)
              AnimatedRadiusLayer(
                center: _userLocation!,
                animation: _radiusController,
                radiusInMeters: widget._nearbyRadiusMeters,
                color: widget._radiusColor,
              ),
            if (visibleItems.isNotEmpty)
              widget._useClustering
                  ? MarkerClusterLayerWidget(
                      options: MarkerClusterLayerOptions(
                        maxClusterRadius: 45,
                        size: const Size(72, 88),
                        markers: visibleItems.map((item) {
                          final imageUrl = widget._markerImage?.call(item.data);
                          return Marker(
                            key: _MarkerDataKey(item.id, imageUrl),
                            point: item.position,
                            width: widget._markerSize,
                            height: widget._markerSize,
                            child: GestureDetector(
                              onTap: () => widget._onTap?.call(item.data),
                              child: DefaultImageMarker(
                                imageUrl: imageUrl,
                                size: widget._markerSize,
                                borderColor: widget._markerBorderColor,
                              ),
                            ),
                          );
                        }).toList(),
                        builder: widget._clusterBuilder ??
                            (context, markers) {
                              // 🧠 Extract up to 2 unique image URLs (SAFE & FAST)
                              final Set<String> imageSet = {};
                              for (final marker in markers) {
                                final key = marker.key;
                                if (key is _MarkerDataKey &&
                                    key.imageUrl != null) {
                                  imageSet.add(key.imageUrl!);
                                  if (imageSet.length == 2) break;
                                }
                              }
                              final images = imageSet.toList();

                              return GestureDetector(
                                onTap: () {
                                  // 🔍 Zoom into cluster on tap (EXPECTED UX)
                                  _animatedMapMove(markers.first.point,
                                      _mapController.camera.zoom + 2);
                                },
                                child: SizedBox(
                                  width: 72,
                                  height: 88,
                                  child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      // 🎯 Teardrop background
                                      CustomPaint(
                                        size: const Size(72, 88),
                                        painter: _TeardropPainter(
                                          color: Colors.black
                                              .withValues(alpha: 0.85),
                                          outlineColor: widget._radiusColor,
                                          outlineWidth: 2.5,
                                        ),
                                      ),

                                      // 🖼️ Image container
                                      Positioned(
                                        top: 6,
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey.shade900,
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              if (images.isEmpty)
                                                const Icon(
                                                  Icons.place_rounded,
                                                  color: Colors.white,
                                                  size: 26,
                                                )
                                              else if (images.length == 1)
                                                _buildCircleImage(
                                                    images.first, 56)
                                              else ...[
                                                Positioned(
                                                  left: 2,
                                                  top: 12,
                                                  child: _buildCircleImage(
                                                      images[0], 38),
                                                ),
                                                Positioned(
                                                  right: 2,
                                                  bottom: 12,
                                                  child: _buildCircleImage(
                                                      images[1], 38),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),

                                      // 🔢 Count badge
                                      Positioned(
                                        top: 2,
                                        right: 6,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: widget._radiusColor,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.white
                                                  .withValues(alpha: 0.9),
                                              width: 1,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.25),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            markers.length.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              height: 1.1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                      ),
                    )
                  : MarkerLayer(
                      markers: visibleItems.map((item) {
                        final imageUrl = widget._markerImage?.call(item.data);
                        return Marker(
                          key: _MarkerDataKey(item.id, imageUrl),
                          point: item.position,
                          width: widget._markerSize,
                          height: widget._markerSize,
                          child: GestureDetector(
                            onTap: () => widget._onTap?.call(item.data),
                            child: DefaultImageMarker(
                              imageUrl: imageUrl,
                              size: widget._markerSize,
                              borderColor: widget._markerBorderColor,
                            ),
                          ),
                        );
                      }).toList(),
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
                    color: Colors.black.withValues(alpha: 0.6),
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

        // 🛡️ Location Permission Feedback (SAFE & SUBTLE)
        if (effectiveShowLocation &&
            _userLocation == null &&
            _locationResult != null &&
            _locationResult != LocationResult.success)
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            left: 20,
            right: 20,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * -20),
                    child: child,
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_off_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _locationResult == LocationResult.serviceDisabled
                            ? 'Location services are disabled'
                            : 'Location permission denied',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => setState(() => _locationResult = null),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCircleImage(String imageUrl, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipOval(
        child: DefaultImageMarker(
          imageUrl: imageUrl,
          size: size,
          borderColor: Colors.transparent, // Border handled by Container
        ),
      ),
    );
  }
}

class _TeardropPainter extends CustomPainter {
  final Color color;
  final Color outlineColor;
  final double outlineWidth;

  _TeardropPainter({
    required this.color,
    required this.outlineColor,
    required this.outlineWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 🎨 Gradient for 3D effect
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color,
        Color.lerp(color, Colors.black, 0.4)!, // Darker shade
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = outlineWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = w / 2;

    // Start from left-center
    path.moveTo(0, r);

    // Top Arc
    path.arcToPoint(
      Offset(w, r),
      radius: Radius.circular(r),
      largeArc: true,
    );

    // Bottom Tip part
    path.quadraticBezierTo(w, h * 0.65, w / 2, h);
    path.quadraticBezierTo(0, h * 0.65, 0, r);

    path.close();

    // 🌑 Drop Shadow (Two layers for depth)
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.5), 6, true);
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.3), 12, true);

    // Draw Fill
    canvas.drawPath(path, paint);

    // Draw Outline
    canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _MarkerDataKey extends ValueKey<String> {
  final String? imageUrl;
  const _MarkerDataKey(super.id, this.imageUrl);
}
