import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppState with ChangeNotifier {
  bool _isOnOps = false;
  int _waterIntake = 0;
  final int _waterGoal = 8; // e.g., 8 glasses
  
  // Ledger
  int _pushups = 0;
  int _situps = 0;
  int _dips = 0;
  int _dailySnacksCompleted = 0;
  final int _dailySnackGoal = 6;
  
  // Intel
  String _kickHeight = 'Mid'; // Low, Mid, High
  int _holdTime = 0; // seconds

  // Weight
  List<Map<String, dynamic>> _weightHistory = [];

  // Movement History
  List<Map<String, dynamic>> _movementHistory = [];

  bool get isOnOps => _isOnOps;
  int get waterIntake => _waterIntake;
  int get waterGoal => _waterGoal;
  int get pushups => _pushups;
  int get situps => _situps;
  int get dips => _dips;
  int get dailySnacksCompleted => _dailySnacksCompleted;
  int get dailySnackGoal => _dailySnackGoal;
  String get kickHeight => _kickHeight;
  int get holdTime => _holdTime;
  List<Map<String, dynamic>> get weightHistory => _weightHistory;
  List<Map<String, dynamic>> get movementHistory => _movementHistory;

  AppState() {
    _loadState();
  }

  void toggleMissionStatus(bool value) {
    _isOnOps = value;
    _saveState();
    notifyListeners();
  }
  
  void completeSnack() {
    _dailySnacksCompleted++;
    _saveState();
    notifyListeners();
  }

  void addWater() {
    _waterIntake++;
    _saveState();
    notifyListeners();
  }
  
  void resetWater() {
    _waterIntake = 0;
    _saveState();
    notifyListeners();
  }

  void updateLedger({int? pushups, int? situps, int? dips}) {
    if (pushups != null) _pushups += pushups;
    if (situps != null) _situps += situps;
    if (dips != null) _dips += dips;
    _saveState();
    notifyListeners();
  }

  void updateIntel({String? kickHeight, int? holdTime}) {
    if (kickHeight != null) _kickHeight = kickHeight;
    if (holdTime != null) _holdTime = holdTime; // You might want to track max or cumulative
    _saveState();
    notifyListeners();
  }

  void addWeight(double weight) {
    _weightHistory.add({
      'date': DateTime.now().toIso8601String(),
      'weight': weight,
    });
    _saveState();
    notifyListeners();
  }

  void addMovementSession(String type, double distance, int duration) {
    _movementHistory.add({
      'date': DateTime.now().toIso8601String(),
      'type': type,
      'distance': distance,
      'duration': duration,
    });
    _saveState();
    notifyListeners();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _isOnOps = prefs.getBool('isOnOps') ?? false;
    
    // Check if it's a new day for daily trackers
    String? lastDate = prefs.getString('lastDate');
    String today = DateTime.now().toIso8601String().split('T')[0];
    
    if (lastDate != today) {
      _waterIntake = 0;
      _pushups = 0;
      _situps = 0;
      _dips = 0;
      _dailySnacksCompleted = 0;
      prefs.setString('lastDate', today);
    } else {
      _waterIntake = prefs.getInt('waterIntake') ?? 0;
      _pushups = prefs.getInt('pushups') ?? 0;
      _situps = prefs.getInt('situps') ?? 0;
      _dips = prefs.getInt('dips') ?? 0;
      _dailySnacksCompleted = prefs.getInt('dailySnacksCompleted') ?? 0;
    }

    _kickHeight = prefs.getString('kickHeight') ?? 'Mid';
    _holdTime = prefs.getInt('holdTime') ?? 0;
    
    String? weightJson = prefs.getString('weightHistory');
    if (weightJson != null) {
      _weightHistory = List<Map<String, dynamic>>.from(json.decode(weightJson));
    }

    String? movementJson = prefs.getString('movementHistory');
    if (movementJson != null) {
      _movementHistory = List<Map<String, dynamic>>.from(json.decode(movementJson));
    }
    
    notifyListeners();
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isOnOps', _isOnOps);
    prefs.setInt('waterIntake', _waterIntake);
    prefs.setInt('pushups', _pushups);
    prefs.setInt('situps', _situps);
    prefs.setInt('dips', _dips);
    prefs.setInt('dailySnacksCompleted', _dailySnacksCompleted);
    prefs.setString('kickHeight', _kickHeight);
    prefs.setInt('holdTime', _holdTime);
    prefs.setString('weightHistory', json.encode(_weightHistory));
    prefs.setString('movementHistory', json.encode(_movementHistory));
    
    // Ensure date is set so we know when to reset
    String today = DateTime.now().toIso8601String().split('T')[0];
    prefs.setString('lastDate', today);
  }
}
