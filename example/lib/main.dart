import 'package:flutter/material.dart';
import 'package:smart_osm_map/smart_osm_map.dart';

void main() {
  runApp(const MyApp());
}

class Place {
  final String name;
  final double lat;
  final double lng;
  final String? image;
  final String description;
  final PlaceType type;

  const Place({
    required this.name,
    required this.lat,
    required this.lng,
    this.image,
    required this.description,
    required this.type,
  });

  Color getTypeColor() {
    switch (type) {
      case PlaceType.restaurant:
        return const Color(0xFFEF4444);
      case PlaceType.hotel:
        return const Color(0xFF3B82F6);
      case PlaceType.landmark:
        return const Color(0xFFF59E0B);
      case PlaceType.hospital:
        return const Color(0xFF10B981);
      case PlaceType.tech:
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF6B7280);
    }
  }
}

enum PlaceType { restaurant, hotel, landmark, hospital, tech }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E40AF),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const ExampleSelector(),
    );
  }
}

// 🎯 Main selector - Modern clean design
class ExampleSelector extends StatelessWidget {
  const ExampleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Map Examples',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xFF111827),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF9FAFB),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            const _SectionHeader(title: 'Basic Features'),
            const SizedBox(height: 12),
            _ExampleTile(
              title: 'Basic Usage',
              subtitle: 'Simple map with markers and clustering',
              icon: Icons.map_outlined,
              example: const BasicExample(),
            ),
            const SizedBox(height: 12),
            _ExampleTile(
              title: 'Location & Nearby',
              subtitle: 'User location with radius filtering',
              icon: Icons.my_location,
              example: const LocationExample(),
            ),
            const SizedBox(height: 12),
            _ExampleTile(
              title: 'Permission Handling',
              subtitle: 'All permission states demonstrated',
              icon: Icons.security,
              example: const PermissionExample(),
            ),
            const SizedBox(height: 24),
            const _SectionHeader(title: 'Advanced Features'),
            const SizedBox(height: 12),
            _ExampleTile(
              title: 'Custom Styling',
              subtitle: 'Custom markers, clusters, and colors',
              icon: Icons.palette,
              example: const StylingExample(),
            ),
            const SizedBox(height: 12),
            _ExampleTile(
              title: 'Performance Test',
              subtitle: '500+ markers with clustering',
              icon: Icons.speed,
              example: const PerformanceExample(),
            ),
            const SizedBox(height: 12),
            _ExampleTile(
              title: 'Network Images',
              subtitle: 'Markers with remote images',
              icon: Icons.cloud_download,
              example: const NetworkImageExample(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6B7280),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ExampleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget example;

  const _ExampleTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.example,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF374151), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF111827),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
        trailing: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 12,
            color: Color(0xFF6B7280),
          ),
        ),
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => example)),
      ),
    );
  }
}

// 📍 Example 1: Basic Usage
class BasicExample extends StatelessWidget {
  const BasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    final places = [
      const Place(
        name: 'India Gate',
        lat: 28.6129,
        lng: 77.2295,
        image: 'assets/images/india_gate.png',
        description: 'War memorial in New Delhi',
        type: PlaceType.landmark,
      ),
      const Place(
        name: 'Red Fort',
        lat: 28.6562,
        lng: 77.2410,
        image: 'assets/images/red_fort.png',
        description: 'Historic Mughal fort',
        type: PlaceType.landmark,
      ),
      const Place(
        name: 'No Image Marker',
        lat: 28.6315,
        lng: 77.2167,
        image: null,
        description: 'Demonstrates default marker',
        type: PlaceType.landmark,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Usage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, size: 20),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Basic Usage',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'This example shows basic map functionality with markers. '
                        'Tap on markers to see details.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF111827),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Got it'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FlutterMapSmart.simple(
        items: places,
        latitude: (p) => p.lat,
        longitude: (p) => p.lng,
        markerImage: (p) => p.image,
        onTap: (place) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tapped: ${place.name}'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: const Color(0xFF111827),
            ),
          );
        },
      ),
    );
  }
}

// 📍 Example 2: Location & Nearby
class LocationExample extends StatefulWidget {
  const LocationExample({super.key});

  @override
  State<LocationExample> createState() => _LocationExampleState();
}

class _LocationExampleState extends State<LocationExample> {
  bool showLocation = false;
  bool enableNearby = false;
  double radiusKm = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location & Nearby')),
      body: Stack(
        children: [
          FlutterMapSmart.simple(
            items: _generateDelhiPlaces(),
            latitude: (p) => p.lat,
            longitude: (p) => p.lng,
            markerImage: (p) => p.image,
            showUserLocation: showLocation,
            enableNearby: enableNearby,
            nearbyRadiusKm: radiusKm,
            radiusColor: const Color(0xFFE0E7FF),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location Controls',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildToggle(
                      icon: Icons.location_on,
                      title: 'Show My Location',
                      value: showLocation,
                      onChanged: (v) => setState(() => showLocation = v),
                    ),
                    const SizedBox(height: 12),
                    _buildToggle(
                      icon: Icons.filter_alt,
                      title: 'Filter Nearby',
                      value: enableNearby,
                      enabled: showLocation,
                      subtitle: 'Within ${radiusKm.toInt()} km',
                      onChanged: (v) => setState(() => enableNearby = v),
                    ),
                    if (enableNearby) ...[
                      const SizedBox(height: 20),
                      _buildRadiusSlider(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
    bool enabled = true,
    String? subtitle,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF6B7280)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF111827),
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: const Color(0xFF1E40AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadiusSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.adjust, size: 16, color: Color(0xFF6B7280)),
            const SizedBox(width: 8),
            Text(
              'Radius: ${radiusKm.toInt()} km',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: radiusKm,
          min: 1,
          max: 50,
          divisions: 49,
          label: '${radiusKm.toInt()} km',
          onChanged: (v) => setState(() => radiusKm = v),
          activeColor: const Color(0xFF1E40AF),
          inactiveColor: const Color(0xFFE5E7EB),
        ),
      ],
    );
  }
}

// 📍 Example 3: Permission Handling
class PermissionExample extends StatefulWidget {
  const PermissionExample({super.key});

  @override
  State<PermissionExample> createState() => _PermissionExampleState();
}

class _PermissionExampleState extends State<PermissionExample> {
  String? permissionStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permission Handling')),
      body: Stack(
        children: [
          FlutterMapSmart.simple(
            items: _generateDelhiPlaces(),
            latitude: (p) => p.lat,
            longitude: (p) => p.lng,
            markerImage: (p) => p.image,
            showUserLocation: true,
            onLocationPermissionGranted: () {
              setState(() => permissionStatus = 'Permission Granted');
            },
            onLocationPermissionDenied: () {
              setState(() => permissionStatus = 'Permission Denied');
            },
            onLocationPermissionDeniedForever: () {
              setState(() => permissionStatus = 'Permission Denied Forever');
            },
            onLocationServiceDisabled: () {
              setState(() => permissionStatus = 'Location Service Disabled');
            },
          ),
          if (permissionStatus != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info, color: const Color(0xFF1E40AF), size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        permissionStatus!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => setState(() => permissionStatus = null),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Permission States',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPermissionItem(
                    'Granted',
                    'User allowed location access',
                  ),
                  _buildPermissionItem('Denied', 'User denied location access'),
                  _buildPermissionItem(
                    'Denied Forever',
                    'User permanently denied',
                  ),
                  _buildPermissionItem('Disabled', 'Location services are off'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFD1D5DB),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 📍 Example 4: Custom Styling
class StylingExample extends StatelessWidget {
  const StylingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Styling')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFF3F4F6),
            child: Row(
              children: [
                Icon(Icons.palette, size: 20, color: const Color(0xFF111827)),
                const SizedBox(width: 12),
                const Text(
                  'Custom markers, clusters, and radius colors',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMapSmart.simple(
              items: _generateDelhiPlaces(),
              latitude: (p) => p.lat,
              longitude: (p) => p.lng,
              markerImage: (p) => p.image,
              markerSize: 64,
              markerBorderColor: const Color(0xFF1E40AF),
              clusterColor: const Color(0xFF1E40AF),
              radiusColor: const Color(0xFFDBEAFE),
              showUserLocation: true,
              enableNearby: true,
              nearbyRadiusKm: 15,
            ),
          ),
        ],
      ),
    );
  }
}

// 📍 Example 5: Performance Test
class PerformanceExample extends StatelessWidget {
  const PerformanceExample({super.key});

  @override
  Widget build(BuildContext context) {
    final places = List.generate(500, (i) {
      final lat = 28.5 + (i % 20) * 0.01;
      final lng = 77.1 + (i ~/ 20) * 0.01;
      return Place(
        name: 'Place $i',
        lat: lat,
        lng: lng,
        image: i % 3 == 0 ? 'assets/images/india_gate.png' : null,
        description: 'Test marker $i',
        type: PlaceType.landmark,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Test'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${places.length} markers',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFFEF3C7),
            child: Row(
              children: [
                Icon(Icons.speed, size: 20, color: const Color(0xFF92400E)),
                const SizedBox(width: 12),
                const Text(
                  'Testing with 500 markers using clustering for optimal performance',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF92400E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMapSmart.simple(
              items: places,
              latitude: (p) => p.lat,
              longitude: (p) => p.lng,
              markerImage: (p) => p.image,
              useClustering: true,
            ),
          ),
        ],
      ),
    );
  }
}

// 📍 Example 6: Network Images
class NetworkImageExample extends StatelessWidget {
  const NetworkImageExample({super.key});

  @override
  Widget build(BuildContext context) {
    final places = [
      const Place(
        name: 'Network Image 1',
        lat: 28.6129,
        lng: 77.2295,
        image: 'https://picsum.photos/200/200?random=1',
        description: 'Remote image marker',
        type: PlaceType.landmark,
      ),
      const Place(
        name: 'Network Image 2',
        lat: 28.6315,
        lng: 77.2167,
        image: 'https://picsum.photos/200/200?random=2',
        description: 'Another remote image',
        type: PlaceType.landmark,
      ),
      const Place(
        name: 'Broken Image',
        lat: 28.6562,
        lng: 77.2410,
        image: 'https://invalid-url-to-test-error.com/image.jpg',
        description: 'Tests error handling',
        type: PlaceType.landmark,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Network Images')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFF3F4F6),
            child: const Row(
              children: [
                Icon(Icons.wifi, size: 20, color: Color(0xFF111827)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Markers load images from network URLs. Broken URLs show error states.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMapSmart.simple(
              items: places,
              latitude: (p) => p.lat,
              longitude: (p) => p.lng,
              markerImage: (p) => p.image,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper function
List<Place> _generateDelhiPlaces() {
  return const [
    Place(
      name: 'India Gate',
      lat: 28.6129,
      lng: 77.2295,
      image: 'assets/images/india_gate.png',
      description: 'War memorial',
      type: PlaceType.landmark,
    ),
    Place(
      name: 'Red Fort',
      lat: 28.6562,
      lng: 77.2410,
      image: 'assets/images/red_fort.png',
      description: 'Historic fort',
      type: PlaceType.landmark,
    ),
    Place(
      name: 'Qutub Minar',
      lat: 28.5245,
      lng: 77.1855,
      image: 'assets/images/qutub_minar.png',
      description: 'Ancient minaret',
      type: PlaceType.landmark,
    ),
    Place(
      name: 'Connaught Place',
      lat: 28.6315,
      lng: 77.2167,
      image: 'assets/images/connaught_place.png',
      description: 'Shopping district',
      type: PlaceType.landmark,
    ),
  ];
}
