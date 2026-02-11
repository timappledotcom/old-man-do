import 'package:flutter/material.dart';
import 'package:old_man_do/models/weekly_schedule.dart';
import 'package:old_man_do/models/technique.dart';
import 'package:old_man_do/models/circuit.dart';

class FieldManualScreen extends StatelessWidget {
  const FieldManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FIELD MANUAL"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildWeeklySchedule(context),
          const SizedBox(height: 16),
          _buildTechniqueGuide(context),
          const SizedBox(height: 16),
          _buildExerciseLibrary(context),
          const SizedBox(height: 16),
          _buildWalkingStrategy(),
          const SizedBox(height: 16),
          _buildRecoveryNotes(),
          const SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "🥋 53 & STRONG",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Martial Longevity Program",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Side Kick Height • Functional Strength • Cardiovascular Health",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySchedule(BuildContext context) {
    return _buildExpandableSection(
      "📅 WEEKLY SCHEDULE",
      Column(
        children: WeeklySchedule.schedule.entries.map((entry) {
          final isToday = entry.key == WeeklySchedule.getTodayName();
          return Card(
            color: isToday ? const Color(0xFF556B2F).withOpacity(0.2) : null,
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isToday)
                        const Icon(Icons.arrow_forward, size: 16, color: Color(0xFF556B2F)),
                      if (isToday) const SizedBox(width: 8),
                      Text(
                        entry.key.toUpperCase(),
                        style: TextStyle(
                          fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                          fontSize: 14,
                          color: isToday ? const Color(0xFF556B2F) : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (entry.value.morning != 'N/A')
                    Row(
                      children: [
                        const Icon(Icons.wb_sunny, size: 14, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(child: Text(entry.value.morning)),
                      ],
                    ),
                  if (entry.value.morning != 'N/A') const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.nightlight_round, size: 14, color: Colors.indigo),
                      const SizedBox(width: 8),
                      Expanded(child: Text(entry.value.evening)),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTechniqueGuide(BuildContext context) {
    final technique = Technique.sideKickPiston;
    return _buildExpandableSection(
      "🎯 TECHNIQUE: ${technique.name.toUpperCase()}",
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            technique.subtitle,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...technique.steps.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF556B2F),
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.value.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.value.description,
                          style: const TextStyle(fontSize: 14, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildExerciseLibrary(BuildContext context) {
    final circuit = Circuit.strengthAndSideKickCircuit;
    final missedClass = Circuit.missedClassFiller;
    
    return _buildExpandableSection(
      "💪 EXERCISE LIBRARY",
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Strength & Side Kick Circuit (Tue/Fri)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            "${circuit.rounds} rounds • ${circuit.restBetweenRounds}s rest between rounds",
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          const SizedBox(height: 12),
          ...circuit.exercises.map((ex) => _buildExerciseItem(ex)),
          const Divider(height: 32),
          const Text(
            "Missed Class Filler (30 min)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ...missedClass.exercises.map((ex) => _buildExerciseItem(ex)),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(CircuitExercise ex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ex.exercise.category == 'Mobility' 
                  ? Colors.blue.withOpacity(0.1)
                  : ex.exercise.category == 'Strength'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              ex.reps,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ex.exercise.title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  ex.exercise.description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalkingStrategy() {
    return _buildExpandableSection(
      "🚶 WALKING STRATEGY",
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: Technique.walkingStrategy.map((tip) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, size: 20, color: Color(0xFF556B2F)),
                const SizedBox(width: 12),
                Expanded(child: Text(tip, style: const TextStyle(fontSize: 14, height: 1.4))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecoveryNotes() {
    return _buildExpandableSection(
      "⚕️ RECOVERY NOTES (AGE 53)",
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: Technique.recoveryNotes.map((note) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.healing, size: 20, color: Colors.red),
                const SizedBox(width: 12),
                Expanded(child: Text(note, style: const TextStyle(fontSize: 14, height: 1.4))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpandableSection(String title, Widget content) {
    return Card(
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        initiallyExpanded: false,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text(
        "\"DISCIPLINE EQUALS FREEDOM\"",
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
    );
  }
}
