import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:old_man_do/models/app_state.dart';
import 'package:old_man_do/models/weekly_schedule.dart';
import 'package:old_man_do/models/circuit.dart';
import 'package:old_man_do/utils/quotes.dart';
import 'package:old_man_do/screens/circuit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isOps = appState.isOnOps;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OLD MAN DO'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => Navigator.pushNamed(context, '/manual'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => Navigator.pushNamed(context, '/analytics'),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The Briefing Room
            _buildBriefingRoom(),
            const SizedBox(height: 20),

            // Today's Mission
            _buildTodaysMission(context),
            const SizedBox(height: 20),

            // Mission Status Toggle
            _buildMissionStatus(context, appState),
            const SizedBox(height: 20),

            // Water Call
            _buildWaterCall(context, appState),
            const SizedBox(height: 20),

            // Modules
            _buildModules(context, isOps),
             const SizedBox(height: 20),
             
             // Quick Ledger View
             _buildQuickLedger(appState),
          ],
        ),
      ),
    );
  }

  Widget _buildBriefingRoom() {
    return Card(
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "BRIEFING ROOM",
              style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            Text(
              Quotes.getQuoteForToday(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysMission(BuildContext context) {
    final today = WeeklySchedule.getToday();
    final dayName = WeeklySchedule.getTodayName();
    
    return Card(
      elevation: 4,
      color: const Color(0xFF2F4F4F),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text(
                  "TODAY'S MISSION - ${dayName.toUpperCase()}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (today.morning != 'N/A') ...[
              Row(
                children: [
                  const Icon(Icons.wb_sunny, color: Colors.orange, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      today.morning,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                const Icon(Icons.nightlight_round, color: Colors.indigo, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    today.evening,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
            if (today.evening.contains('Circuit')) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('START CIRCUIT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF556B2F),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CircuitScreen(
                        circuit: Circuit.strengthAndSideKickCircuit,
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMissionStatus(BuildContext context, AppState appState) {
    bool isOps = appState.isOnOps;
    return Card(
      elevation: 4,
      color: isOps ? const Color(0xFF556B2F) : Colors.blueGrey, // Olive vs Slate
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "MISSION STATUS",
              style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "IN GARRISON",
                  style: TextStyle(
                    color: !isOps ? Colors.white : Colors.white38,
                    fontWeight: !isOps ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Switch(
                  value: isOps,
                  onChanged: (val) => appState.toggleMissionStatus(val),
                  thumbColor: WidgetStateProperty.all(Colors.white),
                  trackColor: WidgetStateProperty.all(Colors.black26),
                ),
                Text(
                  "ON OPS",
                  style: TextStyle(
                     color: isOps ? Colors.white : Colors.white38,
                    fontWeight: isOps ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              isOps 
                ? "FOCUS: Operational Recovery (Joint Lubrication, Static Stretching)" 
                : "FOCUS: Growth & Conditioning (Calisthenics, Extension Holds)",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterCall(BuildContext context, AppState appState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("WATER CALL", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${appState.waterIntake} / ${appState.waterGoal} Glasses"),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: appState.waterIntake > 0 ? () => appState.removeWater() : null,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 32, color: Colors.blue),
                  onPressed: () => appState.addWater(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildModules(BuildContext context, bool isOps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.map),
          label: const Text("TACTICAL MOVEMENT (GPS)"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          onPressed: () => Navigator.pushNamed(context, '/tracker'),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          icon: const Icon(Icons.fitness_center),
          label: const Text("STRENGTH & SIDE KICK CIRCUIT"),
          style: ElevatedButton.styleFrom(
             padding: const EdgeInsets.symmetric(vertical: 20),
             backgroundColor: const Color(0xFF556B2F),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CircuitScreen(
                  circuit: Circuit.strengthAndSideKickCircuit,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          icon: const Icon(Icons.restore),
          label: const Text("MISSED CLASS FILLER (30 MIN)"),
          style: ElevatedButton.styleFrom(
             padding: const EdgeInsets.symmetric(vertical: 20),
             backgroundColor: Colors.orange[800],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CircuitScreen(
                  circuit: Circuit.missedClassFiller,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          icon: const Icon(Icons.restaurant),
          label: const Text("EXERCISE SNACKS (5 MIN)"),
          style: ElevatedButton.styleFrom(
             padding: const EdgeInsets.symmetric(vertical: 20),
             backgroundColor: Colors.blueGrey[800],
          ),
          onPressed: () => Navigator.pushNamed(context, '/snacks'),
        ),
      ],
    );
  }
  
  Widget _buildQuickLedger(AppState appState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("THE LEDGER (TODAY)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem("Pushups", appState.pushups),
                _statItem("Situps", appState.situps),
                _statItem("Dips", appState.dips),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _statItem(String label, int value) {
    return Column(
      children: [
        Text(value.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
