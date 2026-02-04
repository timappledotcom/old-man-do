import 'package:flutter/material.dart';

class FieldManualScreen extends StatelessWidget {
  const FieldManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FIELD MANUAL")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              "1. MISSION STATUS PROTOCOL",
              "The Toggle on the Home Screen dictates your daily operational tempo.\n\n"
              "• IN GARRISON (OFF): Standard operating procedure. Focus on Growth & Conditioning. High reps, strength building.\n"
              "• ON OPS (ON): Recovery mode. Use this on Taekwondo days or when injury recovery is needed. Focus shifts to joint lubrication and static stretching."
            ),
            _buildSection(
              "2. EXERCISE SNACKS",
              "Execute these micro-workouts throughout the day. The goal is frequency, not intensity.\n\n"
              "• ENGAGE the 5-minute timer.\n"
              "• Select MOBILITY for range of motion (best for 'ON OPS').\n"
              "• Select STRENGTH for calisthenics (best for 'IN GARRISON')."
            ),
            _buildSection(
              "3. TACTICAL MOVEMENT",
              "GPS tracking for your daily displacement.\n\n"
              "• PATROL: Standard rucksack or weight vest walk (2 miles).\n"
              "• SHUFFLE: Low-impact jogging. Feet should skim the ground (Airborne Shuffle). Minimize vertical oscillation."
            ),
            _buildSection(
              "4. THE LEDGER & INTEL",
              "• THE LEDGER: Quick-log your daily volume (Pushups, Situps, Dips).\n"
              "• INTEL REPORT: Track metrics that matter—Side Kick Height, Hold Times, and Body Weight trajectory."
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "\"DISCIPLINE EQUALS FREEDOM\"",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F4F4F), // Slate
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
  }
}
