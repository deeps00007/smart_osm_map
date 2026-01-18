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
