# Old Man Do - Martial Longevity App

A Flutter fitness tracking app designed for martial artists over 50, featuring the complete **53 & Strong: Martial Longevity Program**.

## 🥋 Program Features

### Weekly Training Schedule
- **Mon/Thu/Sat**: Taekwondo Class
- **Tue/Fri**: Strength & Side Kick Circuit (3 rounds)
- **Wed**: Active Recovery
- **Sun**: Full Rest
- **Daily**: 2-Mile Walks with Pivot Checks

### Key Components

**Strength & Side Kick Circuit**
- Side Kick Height Boosters (90/90 Hip Switches, Wall-Supported Holds)
- Functional Resistance Training (Slow-Tempo Squats, Bird-Dogs, Doorway Rows)
- 3 rounds with 60-second rest periods

**Missed Class Filler (30 minutes)**
- Makeup workout for missed TKD classes
- Focus on technique and conditioning

**Tactical Movement Tracker**
- GPS-based distance tracking
- Pivot Check reminders every 0.5 miles
- Walk/Shuffle interval tracking

**Exercise Snacks**
- 5-minute micro-workouts throughout the day
- Mobility and Strength options

### Field Manual
Complete reference guide including:
- The Perfect Side Kick (Piston Method)
- Exercise library with form cues
- Walking strategy
- Age 53+ recovery notes

## 🏗️ Technical Details

**Built with:**
- Flutter 3.10.8+
- Provider state management
- Local persistence with SharedPreferences
- GPS tracking with Geolocator
- Background service support

## 📱 Installation

1. Ensure Flutter is installed
2. Navigate to `old_man_do/` directory
3. Run `flutter pub get`
4. Run `flutter run`

## 🛠️ Icon Processing

The `process_icon.py` script converts the app icon to transparent background:

```bash
python3 process_icon.py
```

Requires: `pip install pillow`

## 📊 Tracking Features

- Daily water intake
- Exercise ledger (pushups, situps, dips)
- Side kick height progress
- Weight history
- Movement sessions with distance/duration
- Weekly schedule adherence

## 🎯 Mission Status

Toggle between training modes:
- **In Garrison**: Growth & conditioning focus
- **On Ops**: Recovery and mobility focus (for TKD days)

---

*"Discipline Equals Freedom"*
