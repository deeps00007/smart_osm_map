# smart_osm_map

A production-ready Flutter package for OpenStreetMap that provides easy-to-use clustered markers, image-based markers, user location display, and nearby filtering with animated radius effects.

Built on top of `flutter_map`, this package aims to provide a "plug-and-play" experience with strong UX defaults, privacy-safe location handling, and a clean API.

## ✨ Features

*   **Clustered Markers**: Automatically clusters markers to reduce clutter and improve performance.
*   **Image Markers**: Supports both network images and local asset images for markers.
*   **User Location**: Optional support to show the user's current location with safe permission handling.
*   **Nearby Filtering**: Filter markers within a configurable radius from the user, complete with an animated ripple effect.
*   **Privacy First**: Does not track, store, or transmit user location data. Location is only accessed when explicitly enabled by you.
*   **Customizable**: Control marker size, border colors, cluster colors, and more.
*   **No API Keys**: Uses OpenStreetMap tiles, requiring no API keys for standard usage.

## 🚀 Installation

Add `smart_osm_map` to your `pubspec.yaml`:

```yaml
dependencies:
  smart_osm_map: ^0.0.1
```

## 📱 Usage

### Basic Usage

The simplest way to use `SmartOsmMap` is with the `.simple` constructor. You just need a list of items and functions to extract their location.

```dart
import 'package:smart_osm_map/smart_osm_map.dart';

SmartOsmMap.simple(
  items: myPlaces, // Your list of objects
  latitude: (place) => place.lat,
  longitude: (place) => place.lng,
  markerImage: (place) => place.imageUrl, // Optional image URL
  onTap: (place) {
    print('Tapped on ${place.name}');
  },
)
```

### Enabling User Location & Nearby Filtering

To show the user's location and enable "Nearby" filtering, you need to handle permissions. The package provides hooks for all permission states so you can show the appropriate UI to your users.

```dart
SmartOsmMap.simple(
  items: places,
  latitude: (p) => p.lat,
  longitude: (p) => p.lng,
  
  // Enable features
  showUserLocation: true,
  enableNearby: true,
  nearbyRadiusKm: 10, // Filter within 10km
  
  // Permission Callbacks (Handle these in your UI)
  onLocationPermissionGranted: () {
    print("Location access granted");
  },
  onLocationPermissionDenied: () {
    // Show a snackbar or dialog asking for permission
  },
  onLocationPermissionDeniedForever: () {
    // Direct user to app settings
  },
  onLocationServiceDisabled: () {
    // Ask user to enable GPS
  },
)
```

## ⚙️ Configuration

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

## 🔒 Permissions

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

## 🤝 Privacy & Safety

*   **No Tracking**: `smart_osm_map` does not track user location in the background.
*   **No Data Collection**: Location data is processed locally on the device to render the user layer and calculate distances. It is never sent to any external server by this package.
*   **Store Friendly**: Designed to comply with Apple App Store and Google Play Store privacy guidelines regarding location usage.

## ⚠️ Notes

*   **Large Datasets**: While clustering helps with performance, extremely large datasets (thousands of items) may still impact performance depending on the device.
*   **Tile Servers**: By default, this uses standard OpenStreetMap tiles. Ensure you comply with their [Tile Usage Policy](https://operations.osmfoundation.org/policies/tiles/) for heavy usage, or swap with your own tile provider if needed.
