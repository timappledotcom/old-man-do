class TechniqueStep {
  final String title;
  final String description;
  
  TechniqueStep({required this.title, required this.description});
}

class Technique {
  final String name;
  final String subtitle;
  final List<TechniqueStep> steps;
  
  Technique({
    required this.name,
    required this.subtitle,
    required this.steps,
  });
  
  static Technique sideKickPiston = Technique(
    name: 'The Perfect Side Kick',
    subtitle: 'The "Piston" Method',
    steps: [
      TechniqueStep(
        title: 'Pivot',
        description: 'Turn your standing heel 180° away from the target. This opens the hip joint.',
      ),
      TechniqueStep(
        title: 'Chamber',
        description: 'Pull your knee toward your opposite shoulder; keep the knee higher than the ankle.',
      ),
      TechniqueStep(
        title: 'Extension',
        description: 'Push the heel out in a straight line. Keep the "blade" (outer edge) of the foot horizontal.',
      ),
      TechniqueStep(
        title: 'Retraction',
        description: 'Do not let the leg drop. Pull the knee back to the chest before putting the foot down.',
      ),
    ],
  );
  
  static List<String> walkingStrategy = [
    'The "Good Pace": Your 2-mile walk should be brisk enough that talking is possible but singing is difficult.',
    'The Pivot Check: Every half mile, stop and perform 5 slow-motion chambers to prime your hip\'s internal rotation.',
  ];
  
  static List<String> recoveryNotes = [
    'Joint Check: If your hips feel "pinchy," prioritize the 90/90 switches and reduce kick height for one session.',
    'Hydration: Ensure consistent water intake, especially on TKD days, to keep fascia and tendons supple.',
  ];
}
