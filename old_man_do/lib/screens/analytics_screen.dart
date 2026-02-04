import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:old_man_do/models/app_state.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _holdTimeController = TextEditingController();
  String _selectedKickHeight = 'Mid';
  String _selectedPeriod = 'Daily'; // Daily, Weekly, Monthly, Yearly

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text("INTEL REPORT")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Intel Entry
            _buildIntelEntry(context, appState),
            const SizedBox(height: 30),
            
            // Weight Chart
            const Text("WEIGHT LOSS TRAJECTORY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: appState.weightHistory.isEmpty 
                ? const Center(child: Text("No data yet"))
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: appState.weightHistory.asMap().entries.map((e) {
                            return FlSpot(e.key.toDouble(), e.value['weight']);
                          }).toList(),
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
            ),
            
            const SizedBox(height: 30),
            
            // Movement Stats
            _buildMovementStats(context, appState),
            
            const SizedBox(height: 30),

            // Stats
            const Text("PERFORMANCE STATS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Card(
              child: ListTile(
                title: const Text("Current Side Kick Height"),
                trailing: Text(appState.kickHeight, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Best Hold Time"),
                trailing: Text("${appState.holdTime} sec", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Total Pushups (All Time)"),
                trailing: Text("${appState.pushups}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovementStats(BuildContext context, AppState appState) {
    // Filter logic
    final now = DateTime.now();
    List<Map<String, dynamic>> filteredHistory = appState.movementHistory.where((entry) {
      DateTime date = DateTime.parse(entry['date']);
      switch (_selectedPeriod) {
        case 'Daily':
          return date.year == now.year && date.month == now.month && date.day == now.day;
        case 'Weekly':
          // Simple "this week" logic: same year and week number or within last 7 days?
          // Let's go with "Last 7 Days" for simplicity and utility
          return now.difference(date).inDays < 7;
        case 'Monthly':
          return date.year == now.year && date.month == now.month;
        case 'Yearly':
          return date.year == now.year;
        default:
          return false;
      }
    }).toList();

    double walkDist = 0;
    int walkTime = 0;
    double shuffleDist = 0;
    int shuffleTime = 0;

    for (var entry in filteredHistory) {
      if (entry['type'] == 'Walk') {
        walkDist += entry['distance'];
        walkTime += (entry['duration'] as int);
      } else {
        shuffleDist += entry['distance'];
        shuffleTime += (entry['duration'] as int);
      }
    }

    String formatDuration(int seconds) {
      final duration = Duration(seconds: seconds);
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      return "${twoDigits(duration.inHours)}h ${twoDigitMinutes}m";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("MOVEMENT LOG", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 10),
        
        // Period Selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['Daily', 'Weekly', 'Monthly', 'Yearly'].map((period) {
            final isSelected = _selectedPeriod == period;
            final colorScheme = Theme.of(context).colorScheme;
            return GestureDetector(
              onTap: () => setState(() => _selectedPeriod = period),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: colorScheme.outlineVariant ?? Colors.grey),
                ),
                child: Text(
                  period, 
                  style: TextStyle(
                    color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface, 
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Text("PATROL (WALK)", style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 5),
                      Text("${(walkDist / 1609.34).toStringAsFixed(2)} mi", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(formatDuration(walkTime)),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Text("SHUFFLE (JOG)", style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 5),
                      Text("${(shuffleDist / 1609.34).toStringAsFixed(2)} mi", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(formatDuration(shuffleTime)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIntelEntry(BuildContext context, AppState appState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("UPDATE INTEL", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            // Weight
            Row(
              children: [
                Expanded(child: TextField(controller: _weightController, decoration: const InputDecoration(labelText: "Current Weight (lbs)"), keyboardType: TextInputType.number)),
                IconButton(icon: const Icon(Icons.add), onPressed: () {
                  double? w = double.tryParse(_weightController.text);
                  if (w != null) {
                    appState.addWeight(w);
                    _weightController.clear();
                    FocusScope.of(context).unfocus();
                  }
                }),
              ],
            ),
            
            const SizedBox(height: 10),
            
            // Kick Height
            DropdownButtonFormField<String>(
              // ignore: deprecated_member_use
              value: _selectedKickHeight,
              decoration: const InputDecoration(labelText: "Kick Height"),
              items: const [
                DropdownMenuItem(value: "Low", child: Text("Low")),
                DropdownMenuItem(value: "Mid", child: Text("Mid")),
                DropdownMenuItem(value: "High", child: Text("High")),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedKickHeight = val);
                  appState.updateIntel(kickHeight: val);
                }
              },
            ),

            const SizedBox(height: 10),

            // Hold Time
            Row(
              children: [
                Expanded(child: TextField(controller: _holdTimeController, decoration: const InputDecoration(labelText: "Hold Time (sec)"), keyboardType: TextInputType.number)),
                IconButton(icon: const Icon(Icons.save), onPressed: () {
                   int? t = int.tryParse(_holdTimeController.text);
                  if (t != null) {
                    appState.updateIntel(holdTime: t);
                    _holdTimeController.clear();
                    FocusScope.of(context).unfocus();
                  }
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
