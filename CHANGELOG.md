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
