import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:old_man_do/models/circuit.dart';
import 'package:old_man_do/models/app_state.dart';

class CircuitScreen extends StatefulWidget {
  final Circuit circuit;
  
  const CircuitScreen({super.key, required this.circuit});

  @override
  State<CircuitScreen> createState() => _CircuitScreenState();
}

class _CircuitScreenState extends State<CircuitScreen> {
  int currentRound = 1;
  int currentExerciseIndex = 0;
  bool isResting = false;
  int restTimeRemaining = 0;
  Timer? _timer;
  List<bool> exercisesCompleted = [];
  bool workoutComplete = false;

  @override
  void initState() {
    super.initState();
    exercisesCompleted = List.filled(widget.circuit.exercises.length, false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRestTimer() {
    setState(() {
      isResting = true;
      restTimeRemaining = widget.circuit.restBetweenRounds;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (restTimeRemaining > 0) {
          restTimeRemaining--;
        } else {
          timer.cancel();
          isResting = false;
          currentRound++;
          exercisesCompleted = List.filled(widget.circuit.exercises.length, false);
          currentExerciseIndex = 0;
        }
      });
    });
  }

  void _completeExercise(int index) {
    final circuitEx = widget.circuit.exercises[index];
    
    // Check if this exercise uses dynamic reps (has "dynamic" in reps field)
    if (circuitEx.reps.contains('dynamic')) {
      _showDifficultyDialog(index, circuitEx.exercise.title);
    } else {
      // Static reps (time-based), just mark complete
      setState(() {
        exercisesCompleted[index] = true;
        _checkRoundCompletion();
      });
    }
  }
  
  void _showDifficultyDialog(int index, String exerciseTitle) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('EXERCISE COMPLETE'),
        content: const Text('Was this exercise difficult?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Not difficult - increase reps
              final appState = Provider.of<AppState>(context, listen: false);
              appState.increaseExerciseReps(exerciseTitle);
              setState(() {
                exercisesCompleted[index] = true;
                _checkRoundCompletion();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$exerciseTitle: Reps increased to ${appState.getExerciseReps(exerciseTitle)}! 💪'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('NOT DIFFICULT'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Difficult - keep same reps
              setState(() {
                exercisesCompleted[index] = true;
                _checkRoundCompletion();
              });
            },
            child: const Text('DIFFICULT'),
          ),
        ],
      ),
    );
  }
  
  void _checkRoundCompletion() {
    // Check if all exercises are complete
    if (exercisesCompleted.every((completed) => completed)) {
      if (currentRound < widget.circuit.rounds) {
        // Start rest timer for next round
        _startRestTimer();
      } else {
        // Workout complete!
        workoutComplete = true;
        _showCompletionDialog();
      }
    }
  }

  void _showCompletionDialog() {
    final appState = Provider.of<AppState>(context, listen: false);
    
    // Track circuit completion
    appState.completeSnack();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 MISSION COMPLETE'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Outstanding work, soldier!'),
            const SizedBox(height: 16),
            Text(
              '${widget.circuit.name} completed',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${widget.circuit.rounds} rounds finished'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('RETURN TO BASE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.circuit.name.toUpperCase()),
        centerTitle: true,
      ),
      body: workoutComplete
          ? _buildCompletionView()
          : isResting
              ? _buildRestView()
              : _buildWorkoutView(),
    );
  }

  Widget _buildWorkoutView() {
    final appState = Provider.of<AppState>(context);
    
    return Column(
      children: [
        _buildProgressBar(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: widget.circuit.exercises.length,
            itemBuilder: (context, index) {
              final circuitEx = widget.circuit.exercises[index];
              final isCompleted = exercisesCompleted[index];
              
              // Get dynamic reps if applicable
              String displayReps = circuitEx.reps;
              if (circuitEx.reps.contains('dynamic')) {
                int currentReps = appState.getExerciseReps(circuitEx.exercise.title);
                if (circuitEx.reps.contains('/side') || circuitEx.reps.contains('/leg')) {
                  displayReps = '$currentReps reps/side';
                } else {
                  displayReps = '$currentReps reps';
                }
              }
              
              return Card(
                color: isCompleted ? Colors.green.withOpacity(0.1) : null,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  circuitEx.exercise.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  displayReps,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.amber[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isCompleted)
                            const Icon(Icons.check_circle, color: Colors.green, size: 32)
                          else
                            IconButton(
                              icon: const Icon(Icons.check_circle_outline, size: 32),
                              onPressed: () => _completeExercise(index),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        circuitEx.exercise.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                      if (circuitEx.durationSeconds > 0) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '⏱️ Hold for ${circuitEx.durationSeconds} seconds',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Container(
      color: const Color(0xFF556B2F),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ROUND $currentRound / ${widget.circuit.rounds}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${exercisesCompleted.where((c) => c).length} / ${widget.circuit.exercises.length}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: exercisesCompleted.where((c) => c).length / widget.circuit.exercises.length,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildRestView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer, size: 80, color: Color(0xFF556B2F)),
          const SizedBox(height: 20),
          const Text(
            'REST PERIOD',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            '$restTimeRemaining',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Color(0xFF556B2F),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Prepare for Round ${currentRound + 1}',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              _timer?.cancel();
              setState(() {
                isResting = false;
                currentRound++;
                exercisesCompleted = List.filled(widget.circuit.exercises.length, false);
              });
            },
            child: const Text('SKIP REST'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.military_tech, size: 100, color: Color(0xFF556B2F)),
          const SizedBox(height: 20),
          const Text(
            'MISSION COMPLETE',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            widget.circuit.name,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('RETURN TO BASE'),
          ),
        ],
      ),
    );
  }
}
