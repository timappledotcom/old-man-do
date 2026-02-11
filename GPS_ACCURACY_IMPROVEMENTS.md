# GPS Accuracy Improvements

## Changes Made

### 1. **Highest GPS Accuracy Settings**
- Changed from `LocationAccuracy.high` to `LocationAccuracy.bestForNavigation`
- This uses the highest accuracy available on the device (typically 5-10 meter accuracy)

### 2. **More Frequent Updates**
- **Distance Filter**: Reduced from 10 meters to 1 meter
  - App now gets GPS updates every 1 meter of movement (was 10m)
  - More data points = more accurate distance tracking
- **Interval**: Set to 1 second updates
  - Ensures real-time position tracking

### 3. **Google Play Services Integration**
- Set `forceLocationManager: false` 
- Uses Google Play Services location API (Fused Location Provider)
- More accurate than raw GPS, combines GPS + WiFi + Cell towers

### 4. **Accuracy Filtering**
Added intelligent filtering to reject bad GPS readings:

```dart
// Only accept readings with accuracy better than 20 meters
if (position.accuracy > 20.0) {
  return; // Skip this reading
}
```

### 5. **Speed Validation**
Filters out GPS glitches that show unrealistic movement:

```dart
// Reject speeds faster than 30 km/h (8.33 m/s)
// Prevents GPS errors from adding phantom distance
if (speedMps > 8.33) {
  return; // Skip this reading
}
```

### 6. **Drift Protection**
Ignores tiny movements when stationary:

```dart
// Only count movement > 0.5 meters
// Reduces GPS drift when you're standing still
if (dist > 0.5) {
  // Add to distance
}
```

### 7. **Background Location Permission**
- Added `ACCESS_BACKGROUND_LOCATION` permission
- Allows GPS tracking even when app is in background
- Better for continuous tracking during walks

### 8. **Wake Lock Enabled**
- Keeps CPU awake during GPS tracking
- Prevents Android from throttling location updates to save battery
- Ensures consistent GPS readings

### 9. **Foreground Service**
- Shows persistent notification during GPS tracking
- Prevents Android from killing the app
- Required for reliable background GPS on Android 10+

## Android Manifest Permissions Added

```xml
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION" />
<uses-feature android:name="android.hardware.location.gps" android:required="false" />
```

## Expected Accuracy

With these improvements:

- **Best Case (Clear Sky)**: 3-5 meter accuracy
- **Typical (Urban)**: 5-10 meter accuracy
- **Worst Case (Buildings/Trees)**: 10-20 meter accuracy

Readings with accuracy worse than 20 meters are automatically rejected.

## Battery Impact

These settings will use more battery than the previous configuration:
- Previous: ~5-10% battery per hour
- New: ~10-15% battery per hour (estimated)

Trade-off: More accuracy = more battery usage. This is standard for high-accuracy GPS tracking.

## Testing Recommendations

1. **Start a walk** and watch the distance tracking
2. **Walk a known distance** (e.g., around a track) to verify accuracy
3. **Check GPS signal** - accuracy is best in open areas with clear sky
4. **Compare to other apps** (Strava, Google Fit) on the same route

## Technical Details

### Location Settings Used:
```dart
AndroidSettings(
  accuracy: LocationAccuracy.bestForNavigation,
  distanceFilter: 1,
  forceLocationManager: false,
  intervalDuration: const Duration(seconds: 1),
  foregroundNotificationConfig: const ForegroundNotificationConfig(
    notificationText: "Old Man Do is tracking your movement",
    notificationTitle: "GPS Tracking Active",
    enableWakeLock: true,
  ),
)
```

### Filtering Logic:
1. Accuracy threshold: 20 meters
2. Speed limit: 8.33 m/s (30 km/h)
3. Minimum movement: 0.5 meters
4. Position timestamps validated

## Files Modified

1. `lib/screens/tracker_screen.dart` - GPS settings and filtering logic
2. `android/app/src/main/AndroidManifest.xml` - Permissions and service configuration
