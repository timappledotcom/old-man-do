import 'package:old_man_do/models/exercise.dart';

class CircuitExercise {
  final Exercise exercise;
  final String reps;
  final int durationSeconds;
  
  CircuitExercise({
    required this.exercise,
    required this.reps,
    this.durationSeconds = 0,
  });
}

class Circuit {
  final String name;
  final List<CircuitExercise> exercises;
  final int rounds;
  final int restBetweenRounds;
  
  Circuit({
    required this.name,
    required this.exercises,
    required this.rounds,
    required this.restBetweenRounds,
  });
  
  static Circuit strengthAndSideKickCircuit = Circuit(
    name: 'Strength & Side Kick Circuit',
    rounds: 3,
    restBetweenRounds: 60,
    exercises: [
      // Part A: Side Kick Height Boosters
      CircuitExercise(
        exercise: Exercise(
          title: '90/90 Hip Switches',
          description: 'Sit on floor, legs at 90° angles. Rotate knees side-to-side without using hands.',
          category: 'Mobility',
        ),
        reps: 'dynamic', // Will use AppState progressive reps
      ),
      CircuitExercise(
        exercise: Exercise(
          title: 'Lateral Leg Raises',
          description: 'Lie on side, lift top leg slowly with toes pointed slightly down.',
          category: 'Mobility',
        ),
        reps: 'dynamic/side',
      ),
      CircuitExercise(
        exercise: Exercise(
          title: 'Wall-Supported Holds',
          description: 'Extend a side kick at max height.',
          category: 'Mobility',
        ),
        reps: '20-30 sec/side',
        durationSeconds: 30,
      ),
      // Part B: Functional Resistance
      CircuitExercise(
        exercise: Exercise(
          title: 'Slow-Tempo Squats',
          description: '3 seconds down, 2-second pause at bottom.',
          category: 'Strength',
        ),
        reps: 'dynamic',
      ),
      CircuitExercise(
        exercise: Exercise(
          title: 'Push-Ups with "Plus"',
          description: 'Push shoulder blades apart at the top of the move.',
          category: 'Strength',
        ),
        reps: 'dynamic',
      ),
      CircuitExercise(
        exercise: Exercise(
          title: 'Bird-Dogs',
          description: 'On hands/knees, extend opposite arm and leg. Keep back flat.',
          category: 'Strength',
        ),
        reps: 'dynamic/side',
      ),
      CircuitExercise(
        exercise: Exercise(
          title: 'Doorway Rows',
          description: 'Lean back holding a door frame and pull your chest to your hands.',
          category: 'Strength',
        ),
        reps: 'dynamic',
      ),
      CircuitExercise(
        exercise: Exercise(
          title: 'Calf Raises',
          description: 'Slow, controlled raises to protect the Achilles.',
          category: 'Strength',
        ),
        reps: 'dynamic',
      ),
    ],
  );
  
  static Circuit missedClassFiller = Circuit(
    name: 'Missed Class Filler',
    rounds: 1,
    restBetweenRounds: 0,
    exercises: [
      CircuitExercise(
        exercise: Exercise(
          title: 'Warm-up',
          description: 'Shadow sparring and "gate opener" hip rotations.',
          category: 'Warmup',
        ),
        reps: '5 min',
        durationSeconds: 300,
      ),
      CircuitExercise(
        exercise: Exercise(
          title: 'Slow-Motion Side Kicks',
          description: '5 seconds to extend, 2-second hold, 3 seconds to retract.',
          category: 'Technique',
        ),
        reps: 'dynamic/leg',
      ),
      CircuitExercise(
        exercise: Exercise(
          title: 'Power Roundhouses',
          description: 'Focus on a 180° pivot of the standing foot.',
          category: 'Technique',
        ),
        reps: 'dynamic/leg',
      ),
      CircuitExercise(
        exercise: Exercise(
          title: 'Standard Burpees',
          description: 'Maintain a steady, athletic pace.',
          category: 'Strength',
        ),
        reps: 'dynamic',
      ),
      CircuitExercise(
        exercise: Exercise(
          title: 'Horse Stance Hold',
          description: 'A deep, wide isometric squat to build stance "rooting."',
          category: 'Strength',
        ),
        reps: '20-30 seconds',
        durationSeconds: 30,
      ),
    ],
  );
}
