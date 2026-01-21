# Smart OSM Map

[![Pub Version](https://img.shields.io/pub/v/smart_osm_map.svg)](https://pub.dev/packages/smart_osm_map)
[![Pub Points](https://img.shields.io/pub/points/smart_osm_map?color=2E8B57&label=pub%20points)](https://pub.dev/packages/smart_osm_map/score)
[![Pub Popularity](https://img.shields.io/pub/popularity/smart_osm_map?logo=dart)](https://pub.dev/packages/smart_osm_map/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter Platform](https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter)](https://flutter.dev)

A production-ready Flutter package for OpenStreetMap integration. It provides clustered markers, image support, user location display, and nearby filtering with animated radius effects.

Built on top of `flutter_map`, this package offers a "plug-and-play" experience with strong UX defaults, privacy-safe location handling, and a clean API.

## Showcase

<p align="center">
  <table border="0">
    <tr>
      <td align="center"><b>Map UI with teardrop clusters</b><br/><img src="https://ik.imagekit.io/projectss/Screenshot_1.jpg" width="200"></td>
      <td align="center"><b>Map UI with user location</b><br/><img src="https://ik.imagekit.io/projectss/Screenshot_2.jpg" width="200"></td>
      <td align="center"><b>Map UI with image markers</b><br/><img src="https://ik.imagekit.io/projectss/Screenshot_3.jpg" width="200"></td>
    </tr>
  </table>
</p>

## Features

- **Clustered Markers**: Automatically clusters markers to reduce clutter and improve performance. Can be disabled if needed.
- **Custom Cluster Styling**: Provide your own `clusterBuilder` to customize how clustered markers look.
- **Image Markers**: Supports both network images and local asset images for markers.
- **User Location**: Optional support to show the user's current location with safe permission handling.
- **Nearby Filtering**: Filter markers within a configurable radius from the user, complete with an animated ripple effect.
- **Map Controls**: Flexible control over `initialCenter`, `initialZoom`, `minZoom`, `maxZoom`, and `onMapReady` callbacks.
- **No API Keys**: Uses OpenStreetMap tiles, requiring no API keys for standard usage.

## Installation

Add `smart_osm_map` to your `pubspec.yaml`:

```yaml
dependencies:
  smart_osm_map: ^1.0.0
```

## Usage

### 1. Define Your Data Model

First, define the data you want to display on the map. This can be any Dart class.

```dart
class Place {
  final String name;
  final double lat;
  final double lng;
  final String image; // Asset path or network URL

  const Place({
    required this.name,
    required this.lat,
    required this.lng,
    required this.image,
  });
}
```

### 2. Basic Implementation

Use the `.simple` constructor to map your data list to the map.

```dart
import 'package:smart_osm_map/smart_osm_map.dart';

class MyMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Your list of places
    final List<Place> places = [ /* ... */ ];

    return Scaffold(
      body: SmartOsmMap.simple(
        items: places,
        // Extract location data
        latitude: (place) => place.lat,
        longitude: (place) => place.lng,
        // Extract marker image (optional)
        markerImage: (place) => place.image, 
        // Handle taps
        onTap: (place) {
          print('Tapped on ${place.name}');
        },
      ),
    );
  }
}
```

### 3. Advanced Features & Customization

The following example demonstrates how to enable user location, toggle "Nearby" filtering, and customize the map style within a `StatefulWidget`.

```dart
class SmartMapPlayground extends StatefulWidget {
  @override
  State<SmartMapPlayground> createState() => _SmartMapPlaygroundState();
}

class _SmartMapPlaygroundState extends State<SmartMapPlayground> {
  bool showUserLocation = false;
  bool enableNearby = false;

  @override
  Widget build(BuildContext context) {
    return SmartOsmMap.simple(
      items: places,
      latitude: (p) => p.lat,
      longitude: (p) => p.lng,
      markerImage: (p) => p.image,

      // --- Feature 1: User Location ---
      // Toggle this boolean to show/hide the user's location.
      // The package handles permission requests automatically.
      showUserLocation: showUserLocation,

      // --- Feature 2: Nearby Filtering ---
      // When enabled, only shows items within `nearbyRadiusKm` of the user.
      enableNearby: enableNearby,
      nearbyRadiusKm: 10, 

      // --- Feature 3: Styling ---
      markerSize: 64,
      markerBorderColor: Colors.deepPurple,
      clusterColor: Colors.black87,
      radiusColor: Colors.deepPurple.withOpacity(0.3),
      
      // --- Feature 4: Interaction ---
      onTap: (place) {
        // Handle marker tap (e.g., show a modal or navigate)
        showModalBottomSheet(
          context: context, 
          builder: (_) => Text(place.name),
        );
      },
      
      // --- Feature 5: Permission Handling ---
      // Optional callbacks to handle permission states in your UI
      onLocationPermissionDenied: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permission is required.')),
        );
      },
    );
  }
}
```

## Common Use Cases

<table>
  <tr>
    <td width="300"><img src="https://ik.imagekit.io/projectss/store_locator_mockup.png?updatedAt=1769019651572" width="300"></td>
    <td valign="top">
      <h4>🏬 Store & ATM Locator</h4>
      Perfect for displaying branches or ATMs with custom branding. Use the <code>nearbyRadiusKm</code> to show only the closest locations to the user.
    </td>
  </tr>
</table>

<table>
  <tr>
    <td width="300"><img src="https://ik.imagekit.io/projectss/real_estate_mockup.png?updatedAt=1769019651201" width="300"></td>
    <td valign="top">
      <h4>🏡 Real Estate Lists</h4>
      Show properties on a map with high-quality images. Use clustering to keep the view clean in high-density areas like city centers.
    </td>
  </tr>
</table>

<table>
  <tr>
    <td width="300"><img src="https://ik.imagekit.io/projectss/food_delivery_mockup.png?updatedAt=1769019651379" width="300"></td>
    <td valign="top">
      <h4>🍱 Food Delivery & Services</h4>
      Display partner restaurants or service providers. Use <code>onTap</code> to show detailed menus or service info in a bottom sheet.
    </td>
  </tr>
</table>

## Configuration

| Parameter | Type | Default | Description |
|---|---|---|---|
| `items` | `List<T>` | Required | The list of data objects to display on the map. |
| `latitude` | `double Function(T)` | Required | Function to extract latitude from your data object. |
| `longitude` | `double Function(T)` | Required | Function to extract longitude from your data object. |
| `markerImage` | `String? Function(T)?` | `null` | Function to extract image URL (http/asset) for the marker. |
| `onTap` | `void Function(T)?` | `null` | Callback when a marker is tapped. |
| `showUserLocation` | `bool` | `false` | Whether to show the user's location on the map. |
| `enableNearby` | `bool` | `false` | Whether to filter items based on distance from user. |
| `nearbyRadiusKm` | `double` | `10` | The radius in kilometers for nearby filtering. |
| `markerSize` | `double` | `56` | Size of the marker icons. |
| `minZoom` | `double` | `2.0` | Minimum zoom level (how far you can zoom out). |
| `maxZoom` | `double` | `18.0` | Maximum zoom level (how far you can zoom in). |
| `initialZoom` | `double` | `13.0` | Starting zoom level. |
| `initialCenter` | `LatLng?` | `null` | Starting center coordinates (defaults to first item). |
| `onMapReady` | `VoidCallback?` | `null` | Callback when the map is fully loaded. |
| `useClustering` | `bool` | `true` | Whether to enable marker clustering. |
| `clusterBuilder` | `Widget Function(BuildContext, List<Marker>)?` | `null` | Custom builder for the cluster widget. |

## OS Permissions

This package uses `geolocator` to handle location. You must configure your app for location access.

### Android

Add the following to your `<project>/android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS

Add the following to your `<project>/ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open to show nearby places.</string>
```

## Privacy & Safety

- **No Tracking**: `smart_osm_map` does not track user location in the background.
- **No Data Collection**: Location data is processed locally on the device to render the user layer and calculate distances. It is never sent to any external server by this package.
- **Store Friendly**: Designed to comply with Apple App Store and Google Play Store privacy guidelines regarding location usage.

## Performance & Large Datasets

While `smart_osm_map` is optimized for high performance, following these tips will ensure a smooth 60 FPS experience:

- **Enable Clustering**: For datasets over 100 items, always keep `useClustering: true`. This significantly reduces the number of widgets rendered on screen.
- **Lightweight Models**: Pass only the necessary data to the `items` list. If your items have large nested objects, consider mapping them to a lighter "MapItem" model.
- **Image Optimization**: Avoid using high-resolution 4K images for markers. Use thumbnails (e.g., 200x200px) to reduce memory overhead.
- **Coordinate Precision**: Coordinates are processed locally. For thousands of points, ensure your data source provides clean `double` values.

## Troubleshooting

| Issue | Potential Solution |
|---|---|
| **Map is blank** | Ensure you have an active internet connection and that the device can reach `tile.openstreetmap.org`. |
| **Location not showing** | Double-check that you've added the required permissions to `AndroidManifest.xml` and `Info.plist`. |
| **Asset images missing** | Verify the image paths are correctly defined in your `pubspec.yaml` assets section. |
| **Markers not clickable** | Ensure you haven't placed a broad `GestureDetector` or `IgnorePointer` over the `SmartOsmMap` widget. |
| **App crashes on LatLng** | The package now handles `null` coordinates, but ensure your `latitude` and `longitude` functions return valid numbers or `null`. |

## OS Permissions
