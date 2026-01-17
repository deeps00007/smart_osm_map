import 'package:flutter/material.dart';
import 'package:smart_osm_map/smart_osm_map.dart';

void main() {
  runApp(const MyApp());
}

/// Dummy model
class Place {
  final String name;
  final double lat;
  final double lng;
  final String image;

  Place({
    required this.name,
    required this.lat,
    required this.lng,
    required this.image,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapDemoScreen(),
    );
  }
}

class MapDemoScreen extends StatefulWidget {
  const MapDemoScreen({super.key});

  @override
  State<MapDemoScreen> createState() => _MapDemoScreenState();
}

class _MapDemoScreenState extends State<MapDemoScreen> {
  bool enableLocation = false;

  /// Sample data
  final List<Place> places = [
    Place(
      name: 'Connaught Place',
      lat: 28.6315,
      lng: 77.2167,
      image: 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da',
    ),
    Place(
      name: 'India Gate',
      lat: 28.6129,
      lng: 77.2295,
      image: 'https://images.unsplash.com/photo-1587474260584-136574528ed5',
    ),
    Place(
      name: 'Red Fort',
      lat: 28.6562,
      lng: 77.2410,
      image: 'https://images.unsplash.com/photo-1600697260490-bb3b71b7fcdc',
    ),
    Place(
      name: 'Qutub Minar',
      lat: 28.5245,
      lng: 77.1855,
      image: 'https://images.unsplash.com/photo-1599661046289-e31897846e41',
    ),
  ];

  void _enableUserLocation() {
    setState(() {
      enableLocation = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart OSM Map Example'),
        actions: [
          IconButton(
            icon: Icon(
              enableLocation ? Icons.my_location : Icons.location_searching,
            ),
            tooltip: 'Use my location',
            onPressed: _enableUserLocation,
          ),
        ],
      ),
      body: SmartOsmMap.simple(
        items: places,
        latitude: (p) => p.lat,
        longitude: (p) => p.lng,
        markerImage: (p) => p.image,

        // 🔥 LOCATION FEATURES (CONTROLLED BY BUTTON)
        showUserLocation: enableLocation,
        focusOnUser: enableLocation,
        enableNearby: enableLocation,
        nearbyRadiusKm: 10,

        // 🎨 CUSTOMIZATION
        markerSize: 56,
        markerBorderColor: Colors.green,
        clusterColor: Colors.black,
        radiusColor: Colors.blue,

        onTap: (place) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tapped: ${place.name}'),
            ),
          );
        },
      ),
    );
  }
}
