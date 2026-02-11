class Exercise {
  final String title;
  final String description;
  final String category; // Mobility or Strength
  final int durationSeconds;
  final String? reps; // e.g., "10-15 reps", "30 seconds", "AMRAP"

  Exercise({
    required this.title,
    required this.description,
    required this.category,
    this.durationSeconds = 60,
    this.reps,
  });

  static List<Exercise> mobilitySnacks = [
    Exercise(
      title: "90/90 Hip Switches",
      description: "Sit with legs at 90-degree angles. Rotate knees to the opposite side without using hands.",
      category: "Mobility",
      reps: "Start: 5 reps",
    ),
    Exercise(
      title: "Wall-Supported Side Kick Holds",
      description: "Stand by a wall. Extend side kick at max height. Point heel at target, rotate hip over.",
      category: "Mobility",
      reps: "20-30 sec hold/side",
    ),
    Exercise(
      title: "Frog Stretch",
      description: "On knees, spread them wide, feet flat. Sink hips back.",
      category: "Mobility",
      reps: "20-30 seconds",
    ),
    Exercise(
      title: "Pigeon Pose",
      description: "One leg tucked forward, other leg straight back. Focus on glute release.",
      category: "Mobility",
      reps: "20-30 sec/side",
    ),
  ];

  static List<Exercise> strengthSnacks = [
    Exercise(
      title: "Pushups",
      description: "Elbows tucked 45 degrees. 2-second descent, explosive ascent.",
      category: "Strength",
      reps: "Start: 5 reps",
    ),
    Exercise(
      title: "Dips",
      description: "Use sturdy bench/chair. Keep back close to the seat to protect shoulders.",
      category: "Strength",
      reps: "Start: 5 reps",
    ),
    Exercise(
      title: "Situps",
      description: "Slow, vertebra-by-vertebra roll. Touch elbows to knees.",
      category: "Strength",
      reps: "Start: 5 reps",
    ),
    Exercise(
      title: "Single-Leg RDL",
      description: "Hinge at hips on one leg, keep hips level. Stretch the standing hamstring.",
      category: "Strength",
      reps: "Start: 5 reps/leg",
    ),
    Exercise(
      title: "Side Plank Leg Lifts",
      description: "Hold side plank; lift top leg into kick position.",
      category: "Strength",
      reps: "Start: 5 lifts/side",
    ),
  ];
}
