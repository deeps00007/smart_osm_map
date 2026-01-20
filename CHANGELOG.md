## 0.3.1

* **Robustness & Error Handling**:
  * **Null Safety**: `SmartOsmMap.simple` now handles nullable coordinate functions and gracefully skips items with missing coordinates.
  * **Image Fallbacks**: Enhanced `DefaultImageMarker` with a modern placeholder UI for broken or missing marker images.
  * **Permission Feedback**: Added a built-in UI overlay to notify users when location permissions are denied or location services are disabled.
* **Maintenance**:
  * Simplified library exports by including `latlong2` for easier access to `LatLng`.

## 0.3.0

* **New Features (Reviewer Feedback)**:
  * Added `maxZoom` parameter to control maximum zoom level.
  * Added `initialZoom` and `initialCenter` for flexible map initialization.
  * Added `onMapReady` callback for post-initialization logic.
  * Added `useClustering` boolean to enable/disable marker grouping.
  * Added `clusterBuilder` to support custom cluster widgets and icons.
* **Example App**:
  * Added interactive "Use Clustering" toggle to demonstration panel.
  * Added map initialization feedback via `onMapReady` snackbar.
* **Documentation**:
  * Updated README with the new configuration parameters and features.

## 0.2.1

* **Documentation**:
  * Enhanced `README.md` with additional screenshots showing user location and local image markers.
  * Optimized table layout for better visual presentation.

## 0.2.0

* **Features**:
  * **Custom Teardrop Clusters**: Implemented a premium teardrop-shaped cluster UI with 3D gradients and overlapping avatar images.
  * **Radiation Animation**: Added a ripple-effect radiation animation for the nearby radius layer.
  * **Smooth Navigation**: Implemented high-performance "Fly-To" animations for smooth map transitions.
  * **Advanced Positioning**: Added auto-centering on user location with configurable permission callbacks.
  * **Asset Image Support**: Markers now support local assets in addition to network URLs.
* **Fixes**:
  * Fixed Android build failure by removing deprecated `package` attribute from `AndroidManifest.xml`.
  * Resolved "Duplicate keys found" error in marker clustering by implementing unique `_MarkerDataKey`.
  * Replaced deprecated `withOpacity` calls with `.withValues()`.
* **Example App**:
  * Completely overhauled the example app with a modern Glassmorphic design, custom search header, and interactive place selection.

## 0.1.0

* **Features**:
  * Added `minZoom` parameter to limit map zoom-out level.
  * Added smooth animated zoom when tapping on clusters.
* **Fixes**:
  * Fixed issue where markers were not clickable during radius animation.
  * Fixed `Null check operator used on a null value` error in `MarkerClusterLayerWidget`.
  * Fixed map reloading/flashing during user location updates.
* **Maintenance**:
  * Upgraded dependencies to latest compatible versions (`flutter_map` 8.x, `geolocator` 14.x).
  * Removed deprecated `withOpacity` calls in favor of `withValues`.
  * Resolved all static analysis warnings.
  * Comprehensive README documentation and license updates.

## 0.0.1

* Initial release.
