class DailyActivity {
  final String morning;
  final String evening;
  
  DailyActivity({required this.morning, required this.evening});
}

class WeeklySchedule {
  static final Map<String, DailyActivity> schedule = {
    'Monday': DailyActivity(
      morning: '2-Mile Walk',
      evening: 'Taekwondo Class',
    ),
    'Tuesday': DailyActivity(
      morning: '2-Mile Walk',
      evening: 'Strength & Side Kick Circuit',
    ),
    'Wednesday': DailyActivity(
      morning: '2-Mile Walk',
      evening: 'Active Recovery (Light Stretching)',
    ),
    'Thursday': DailyActivity(
      morning: '2-Mile Walk',
      evening: 'Taekwondo Class',
    ),
    'Friday': DailyActivity(
      morning: '2-Mile Walk',
      evening: 'Strength & Side Kick Circuit',
    ),
    'Saturday': DailyActivity(
      morning: 'N/A',
      evening: 'Taekwondo Class',
    ),
    'Sunday': DailyActivity(
      morning: 'Full Rest',
      evening: 'No structured exercise',
    ),
  };
  
  static DailyActivity getToday() {
    final today = DateTime.now().weekday;
    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return schedule[dayNames[today - 1]]!;
  }
  
  static String getTodayName() {
    final today = DateTime.now().weekday;
    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return dayNames[today - 1];
  }
}
