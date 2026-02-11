# Changelog

## v2.1.0 - Progressive Reps & GPS Accuracy

### Major Features Added
- **Progressive Rep System**: Intelligent rep progression for all exercises
  - All rep-based exercises start at 5 reps
  - After completion, app asks: "Was this difficult?"
  - If not difficult, reps automatically increase by +2
  - Progress persists across sessions (keeps up with your strength gains!)
- **Maximum GPS Accuracy**: Industry-leading location tracking
  - Upgraded to `LocationAccuracy.bestForNavigation` (highest available)
  - Updates every 1 meter (was 10m) for precise distance tracking
  - Smart filtering rejects inaccurate readings (>20m accuracy threshold)
  - Speed validation blocks GPS glitches (rejects >30 km/h speeds)
  - Drift protection ignores movement <0.5 meters when stationary
  - Google Play Services integration (GPS + WiFi + Cell towers)

### Improvements
- All stretches now 20-30 seconds max (no longer than 30 sec)
- Exercise cards show current dynamic reps in amber
- Difficulty prompts after rep-based exercise completion
- Wake lock keeps CPU active during GPS tracking
- Background location permission for continuous tracking
- Foreground service notification for reliable GPS

### Technical Changes
- Added `exerciseReps` Map to AppState with SharedPreferences persistence
- Updated Exercise model with optional `reps` field
- Circuit exercises use 'dynamic' reps that read from AppState
- Enhanced `_updateDistance()` with accuracy/speed/drift filtering
- AndroidManifest: Added `ACCESS_BACKGROUND_LOCATION` permission
- AndroidManifest: Added `FOREGROUND_SERVICE_LOCATION` permission
- AndroidManifest: GPS hardware feature declaration

### Expected GPS Accuracy
- Clear sky: 3-5 meter accuracy
- Urban areas: 5-10 meter accuracy
- Buildings/trees: 10-20 meter accuracy
- Trade-off: ~10-15% battery/hour (increased from 5-10% for accuracy)

## v2.0.0 - Martial Longevity Program Integration

### Major Features Added
- **Complete 53 & Strong Program**: Full weekly schedule with daily mission guidance
- **Enhanced Field Manual**: Comprehensive exercise library with expandable sections
  - Weekly training schedule with today's highlight
  - Perfect Side Kick technique (Piston Method)
  - Complete exercise library for circuits
  - Walking strategy and recovery notes
- **Circuit Workout Screen**: Interactive workout system
  - Strength & Side Kick Circuit (Tue/Fri, 3 rounds)
  - Missed Class Filler (30-minute makeup workout)
  - Round tracking and rest timers
  - Exercise completion checkboxes
- **Today's Mission Card**: Home screen shows current day's scheduled activities
- **Pivot Check Reminders**: GPS tracker reminds every 0.5 miles during walks

### New Data Models
- `WeeklySchedule`: 7-day program structure
- `Circuit`: Workout circuits with exercises and timing
- `Technique`: Form cues and instruction system

### Improvements
- Fixed water intake decrement functionality (added removeWater method)
- Updated deprecated Switch API to WidgetStateProperty
- Enhanced home screen with 4 workout modules
- Added proper program description to pubspec.yaml
- Updated README with comprehensive program documentation
- Improved .gitignore for better repository management

### Bug Fixes
- Water tracker now properly decrements
- Fixed Switch widget deprecation warnings

## v1.1.0 - Background Service & Interval Tracking
- Added background service support
- Interval tracking for walks and shuffle

## v1.0.0 - Initial Release
- Basic exercise tracking
- Water intake monitoring
- GPS movement tracking
- Exercise snacks system
