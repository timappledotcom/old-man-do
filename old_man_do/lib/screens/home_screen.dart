import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:old_man_do/models/app_state.dart';
import 'package:old_man_do/utils/quotes.dart';

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
                  // ignore: deprecated_member_use
                  activeColor: Colors.white,
                  activeTrackColor: Colors.black26,
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
                  onPressed: appState.waterIntake > 0 ? () {
                    // Need a remove method or just reset for now, user asked for add/log
                    // Implementing simple decrement logic locally if needed or just add
                     // appState.removeWater(); // Not implemented yet
                  } : null,
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
