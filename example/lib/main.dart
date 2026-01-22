import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_osm_map/smart_osm_map.dart';

void main() {
  runApp(const MyApp());
}

/// Sample model (simulates real user data)
class Place {
  final String name;
  final double lat;
  final double lng;
  final String image;
  final String description;

  const Place({
    required this.name,
    required this.lat,
    required this.lng,
    required this.image,
    required this.description,
  });
}

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
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          bodyLarge: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
      home: const SmartMapPlayground(),
    );
  }
}

class SmartMapPlayground extends StatefulWidget {
  const SmartMapPlayground({super.key});

  @override
  State<SmartMapPlayground> createState() => _SmartMapPlaygroundState();
}

class _SmartMapPlaygroundState extends State<SmartMapPlayground> {
  bool showUserLocation = false;
  bool enableNearby = false;
  bool useClustering = true;
  Place? selectedPlace;

  final List<Place> places = const [
    Place(
      name: 'India Gate',
      lat: 28.6129,
      lng: 77.2295,
      image: 'assets/images/india_gate.png',
      description:
          'The India Gate is a war memorial located astride the Rajpath.',
    ),
    Place(
      name: 'Connaught Place',
      lat: 28.6315,
      lng: 77.2167,
      image: 'assets/images/connaught_place.png',
      description:
          'One of the main financial, commercial and business centres in New Delhi.',
    ),
    Place(
      name: 'Red Fort',
      lat: 28.6562,
      lng: 77.2410,
      image: 'assets/images/red_fort.png',
      description:
          'A historic fort in the city of Delhi in India that served as the main residence of the Mughal Emperors.',
    ),
    Place(
      name: 'Qutub Minar',
      lat: 28.5245,
      lng: 77.1855,
      image: 'assets/images/qutub_minar.png',
      description:
          'A minaret not far from the Qutb complex. It is a UNESCO World Heritage Site.',
    ),
    // Noida Sector 62 Additions
    Place(
      name: 'Radisson Blu MBD Hotel',
      lat: 28.5672,
      lng: 77.3215,
      image: 'assets/images/luxury_hotel.png',
      description:
          'Luxury hotel in Noida Sector 18, nearby Sector 62 connectivity.',
    ),
    Place(
      name: 'Ginger Hotel Noida',
      lat: 28.6208,
      lng: 77.3639,
      image: 'assets/images/budget_hotel.png',
      description: 'Comfortable stay in the heart of Sector 62, Noida.',
    ),
    Place(
      name: 'Ascent Biz Hotel',
      lat: 28.6258,
      lng: 77.3719,
      image: 'assets/images/budget_hotel.png',
      description:
          'Modern hotel located opposite the Expo Centre in Sector 62.',
    ),
    Place(
      name: 'Tech Mahindra Campus',
      lat: 28.6189,
      lng: 77.3732,
      image: 'assets/images/tech_campus.png',
      description: 'Major IT tech park and campus in Sector 62.',
    ),
    Place(
      name: 'Fortis Hospital',
      lat: 28.6183,
      lng: 77.3735,
      image: 'assets/images/hospital.png',
      description: 'A leading multi-speciality hospital in Sector 62.',
    ),
    // Sector 66 & 61 Additions
    Place(
      name: 'Mamura Chowk',
      lat: 28.6045,
      lng: 77.3768,
      image: 'assets/images/busy_intersection.png',
      description: 'Busy intersection near Sector 66.',
    ),
    Place(
      name: 'Shopprix Mall',
      lat: 28.6010,
      lng: 77.3630,
      image: 'assets/images/shopping_mall.png',
      description: 'Popular shopping mall in Sector 61.',
    ),
    Place(
      name: 'Park Plaza Noida',
      lat: 28.6052,
      lng: 77.3621,
      image: 'assets/images/luxury_hotel.png',
      description: 'Upscale hotel with modern amenities in Sector 55/61.',
    ),
    Place(
      name: 'Sai Baba Mandir',
      lat: 28.5998,
      lng: 77.3590,
      image: 'assets/images/temple.png',
      description: 'Famous spiritual landmark near Sector 61.',
    ),
    // Distant Places (> 10km)
    Place(
      name: 'Taj Mahal',
      lat: 27.1751,
      lng: 78.0421,
      image: 'assets/images/taj_mahal.png',
      description:
          'Mausoleum in Agra (approx 180km away). Should disappear when Nearby is ON.',
    ),
    Place(
      name: 'Cyber Hub',
      lat: 28.4950,
      lng: 77.0895,
      image: 'assets/images/tech_campus.png',
      description:
          'Dining and entertainment hub in Gurgaon (approx 30km away).',
    ),
  ];

  // void _requestLocation() {
  //   setState(() {
  //     showUserLocation = true;
  //     enableNearby = true;
  //   });
  // }

  void _resetAll() {
    setState(() {
      showUserLocation = false;
      enableNearby = false;
      selectedPlace = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 🗺️ MAP LAYER
          SmartOsmMap.simple(
            items: places,
            latitude: (p) => p.lat,
            longitude: (p) => p.lng,
            markerImage: (p) => p.image,

            // 🔥 CORE FEATURES
            showUserLocation: showUserLocation,
            enableNearby: enableNearby,
            nearbyRadiusKm: 10,
            useClustering: useClustering,

            // 🛠️ NEW FEEDBACK FEATURES
            maxZoom: 18,
            initialZoom: 13,
            initialCenter: const LatLng(
              28.6129,
              77.2295,
            ), // Center on India Gate
            onMapReady: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Map is ready!')));
            },

            // 🎨 STYLE CUSTOMIZATION
            markerSize: 64,
            markerBorderColor: Theme.of(context).primaryColor,
            clusterColor: Colors.black87,
            radiusColor: Theme.of(context).primaryColor,

            onTap: (place) {
              setState(() {
                selectedPlace = place;
              });
            },
          ),

          // 🧠 FLOATING HEADER
          Positioned(top: 0, left: 0, right: 0, child: _buildHeader(context)),

          // 🧩 BOTTOM CONTROLS & INFO
          Positioned(
            left: 16,
            right: 16,
            bottom: 32,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (selectedPlace != null) _buildPlaceCard(selectedPlace!),
                const SizedBox(height: 16),
                _buildControlPanel(context),
              ],
            ),
          ),

          // 📍 FLOATING ACTION BUTTON
          // Positioned(
          //   right: 16,
          //   bottom: selectedPlace != null
          //       ? 340
          //       : 250, // Adjust position based on card visibility
          //   child: FloatingActionButton(
          //     onPressed: _requestLocation,
          //     backgroundColor: Theme.of(context).primaryColor,
          //     foregroundColor: Colors.white,
          //     tooltip: 'My Location',
          //     child: const Icon(Icons.my_location),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.map_outlined,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Explore Delhi',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(221, 255, 255, 255),
                              ),
                        ),
                        const Text(
                          'Interactive Map Demo',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(137, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _resetAll,
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Reset View',
                    style: IconButton.styleFrom(
                      foregroundColor: const Color.fromARGB(137, 255, 255, 255),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSwitch(
                title: 'Live Location',
                subtitle: 'Show your current position',
                value: showUserLocation,
                icon: Icons.person_pin_circle,
                onChanged: (v) {
                  setState(() {
                    showUserLocation = v;
                    if (!v) enableNearby = false;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(color: Colors.white12, height: 1),
              ),
              _buildSwitch(
                title: 'Nearby Places',
                subtitle: 'Filter within 10 km',
                value: enableNearby,
                icon: Icons.radar,
                onChanged: showUserLocation
                    ? (v) => setState(() => enableNearby = v)
                    : null,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(color: Colors.white12, height: 1),
              ),
              _buildSwitch(
                title: 'Use Clustering',
                subtitle: 'Group nearby markers',
                value: useClustering,
                icon: Icons.grid_view_rounded,
                onChanged: (v) => setState(() => useClustering = v),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool>? onChanged,
  }) {
    final isDisabled = onChanged == null;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isDisabled ? Colors.white38 : Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDisabled ? Colors.white38 : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: isDisabled ? Colors.white24 : Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: Theme.of(context).primaryColor,
          inactiveTrackColor: Colors.white24,
        ),
      ],
    );
  }

  Widget _buildPlaceCard(Place place) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              place.image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  place.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => selectedPlace = null),
            icon: const Icon(Icons.close, color: Colors.black45),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
