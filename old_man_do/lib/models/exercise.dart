class Exercise {
  final String title;
  final String description;
  final String category; // Mobility or Strength
  final int durationSeconds;

  Exercise({
    required this.title,
    required this.description,
    required this.category,
    this.durationSeconds = 60, // Default 1 min per exercise in the block? Or just instruction
  });

  static List<Exercise> mobilitySnacks = [
    Exercise(
      title: "90/90 Hip Switches",
      description: "Sit with legs at 90-degree angles. Rotate knees to the opposite side without using hands.",
      category: "Mobility",
    ),
    Exercise(
      title: "Wall-Supported Side Kick Holds",
      description: "Stand by a wall. Extend side kick at max height. Point heel at target, rotate hip over. Hold for 10-30 seconds.",
      category: "Mobility",
    ),
    Exercise(
      title: "Frog Stretch",
      description: "On knees, spread them wide, feet flat. Sink hips back.",
      category: "Mobility",
    ),
    Exercise(
      title: "Pigeon Pose",
      description: "One leg tucked forward, other leg straight back. Focus on glute release.",
      category: "Mobility",
    ),
  ];

  static List<Exercise> strengthSnacks = [
    Exercise(
      title: "Pushups",
      description: "Elbows tucked 45 degrees. 2-second descent, explosive ascent.",
      category: "Strength",
    ),
    Exercise(
      title: "Dips",
      description: "Use sturdy bench/chair. Keep back close to the seat to protect shoulders.",
      category: "Strength",
    ),
    Exercise(
      title: "Situps",
      description: "Slow, vertebra-by-vertebra roll. Touch elbows to knees.",
      category: "Strength",
    ),
    Exercise(
      title: "Single-Leg RDL",
      description: "Hinge at hips on one leg, keep hips level. Stretch the standing hamstring.",
      category: "Strength",
    ),
    Exercise(
      title: "Side Plank Leg Lifts",
      description: "Hold side plank; lift top leg into kick position.",
      category: "Strength",
    ),
  ];
}
