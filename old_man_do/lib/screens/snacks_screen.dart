import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:old_man_do/models/app_state.dart';
import 'package:old_man_do/models/exercise.dart';

class SnacksScreen extends StatefulWidget {
  const SnacksScreen({super.key});

  @override
  State<SnacksScreen> createState() => _SnacksScreenState();
}

class _SnacksScreenState extends State<SnacksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Timer? _timer;
  int _remainingSeconds = 300; // 5 minutes
  bool _isTimerRunning = false;
  
  // Ledger inputs
  final TextEditingController _pushupsController = TextEditingController();
  final TextEditingController _situpsController = TextEditingController();
  final TextEditingController _dipsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with 2 tabs
    _tabController = TabController(length: 2, vsync: this);
    _checkDailySnacks();
  }

  int _dailySnackCount = 0;
  final int _snackGoal = 6;

  Future<void> _checkDailySnacks() async {
    // In a real app we'd load this from SharedPreferences or AppState
    // For now we will hook into AppState in build or just local state for session
    // Let's use AppState to store snack count properly
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Adjust tab based on mission status
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.isOnOps) {
      _tabController.animateTo(0); // Mobility
    } else {
      _tabController.animateTo(1); // Strength
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    _pushupsController.dispose();
    _situpsController.dispose();
    _dipsController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isTimerRunning) return;
    setState(() {
      _isTimerRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _stopTimer();
        // Play sound or vibrate here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("MISSION COMPLETE: 5 Minutes reached.")),
        );
        Provider.of<AppState>(context, listen: false).completeSnack();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _remainingSeconds = 300;
    });
  }

  String _formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("EXERCISE SNACKS"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "MOBILITY"),
            Tab(text: "STRENGTH"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Timer Section
          Container(
            color: Colors.black12,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("TACTICAL TIMER (5 MIN)", style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF556B2F), // Olive
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "GOAL: ${appState.dailySnacksCompleted} / ${appState.dailySnackGoal}",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Text(
                  _formatTime(_remainingSeconds),
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isTimerRunning ? null : _startTimer,
                      child: const Text("ENGAGE"),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: _isTimerRunning ? _stopTimer : null,
                      child: const Text("HOLD"),
                    ),
                    const SizedBox(width: 10),
                    IconButton(icon: const Icon(Icons.refresh), onPressed: _resetTimer),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildExerciseList(Exercise.mobilitySnacks, false, appState.isOnOps),
                _buildExerciseList(Exercise.strengthSnacks, true, !appState.isOnOps),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () => _showLedgerDialog(context, appState),
      ),
    );
  }

  Widget _buildExerciseList(List<Exercise> exercises, bool isStrength, bool isRecommended) {
    return Column(
      children: [
        if (!isRecommended)
          Container(
            width: double.infinity,
            color: Colors.orange[800],
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "WARNING: OUTSIDE MISSION PARAMETERS",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        if (isRecommended)
          Container(
             width: double.infinity,
            color: const Color(0xFF556B2F), // Olive
            padding: const EdgeInsets.all(8.0),
             child: const Text(
              "MISSION PRIORITY: AUTHORIZED",
              textAlign: TextAlign.center,
               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: exercises.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final ex = exercises[index];
              final isDark = Theme.of(context).brightness == Brightness.dark;
              
              // Define colors based on recommendation status
              // Recommended: Military Slate/Olive with White Text (Active)
              // Not Recommended: Greyed out / Muted (Inactive)
              
              final cardColor = isRecommended 
                  ? Theme.of(context).colorScheme.surface // Use surface (dark or light)
                  : (isDark ? Colors.grey[900] : Colors.grey[300]);
              
              final textColor = isRecommended
                  ? Theme.of(context).colorScheme.onSurface
                  : (isDark ? Colors.white38 : Colors.black38);

              // Override for high visibility if the default surface isn't contrasting enough
              // Actually, let's use the Slate color for recommended items to pop against the background
              final activeCardColor = const Color(0xFF2F4F4F); // Slate
              final activeTextColor = Colors.white;
              
              final inactiveCardColor = isDark ? Colors.black45 : Colors.grey[300];
              final inactiveTextColor = isDark ? Colors.grey[600] : Colors.grey[600];

              return Card(
                color: isRecommended ? activeCardColor : inactiveCardColor,
                child: ListTile(
                  title: Text(
                    ex.title, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: isRecommended ? activeTextColor : inactiveTextColor
                    )
                  ),
                  subtitle: Text(
                    ex.description,
                    style: TextStyle(
                      color: isRecommended ? activeTextColor.withOpacity(0.9) : inactiveTextColor?.withOpacity(0.8)
                    )
                  ),
                  trailing: Icon(
                    isStrength ? Icons.fitness_center : Icons.accessibility_new,
                    color: isRecommended ? activeTextColor : inactiveTextColor,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showLedgerDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("UPDATE LEDGER"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _pushupsController, decoration: const InputDecoration(labelText: "Pushups"), keyboardType: TextInputType.number),
            TextField(controller: _situpsController, decoration: const InputDecoration(labelText: "Situps"), keyboardType: TextInputType.number),
            TextField(controller: _dipsController, decoration: const InputDecoration(labelText: "Dips"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("CANCEL")),
          ElevatedButton(
            onPressed: () {
              int p = int.tryParse(_pushupsController.text) ?? 0;
              int s = int.tryParse(_situpsController.text) ?? 0;
              int d = int.tryParse(_dipsController.text) ?? 0;
              appState.updateLedger(pushups: p, situps: s, dips: d);
              _pushupsController.clear();
              _situpsController.clear();
              _dipsController.clear();
              Navigator.pop(ctx);
            },
            child: const Text("LOG INTEL"),
          ),
        ],
      ),
    );
  }
}
