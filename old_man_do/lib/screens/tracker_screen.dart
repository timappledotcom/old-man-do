import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';
import 'package:old_man_do/models/app_state.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  bool _isTracking = false;
  bool _isShuffle = false; // false = Patrol (Walk), true = Shuffle (Jog)
  
  double _distance = 0.0; // meters
  Duration _duration = Duration.zero;
  Timer? _timer;
  StreamSubscription<Position>? _positionStream;

  @override
  void dispose() {
    _timer?.cancel();
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _startTracking() async {
    var status = await Permission.location.request();
    if (!mounted) return;
    if (status.isGranted) {
      setState(() {
        _isTracking = true;
        _distance = 0.0;
        _duration = Duration.zero;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _duration += const Duration(seconds: 1);
        });
      });

      final LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
        (Position? position) {
          if (position != null) {
            // In a real app, we'd calculate distance between points.
            // Simplified here: just accumulating simple distance if we had previous point.
            // For now, let's just use speed * time or mock it, but Geolocator gives us coordinates.
            // Better to just store start position and calculate total, but that's straight line.
            // Accumulating delta is better.
            // Implementing a simplified delta accumulator would require storing 'lastPosition'.
            // For this snippet, I'll omit the complex geocalc logic and assume we just want to start the mechanism.
            // Let's implement a basic accumulation.
            _updateDistance(position);
          }
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location permission required for GPS tracking.")));
    }
  }

  Position? _lastPosition;
  void _updateDistance(Position position) {
    if (_lastPosition != null) {
      final double dist = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      setState(() {
        _distance += dist;
      });
    }
    _lastPosition = position;
  }

  void _stopTracking() {
    _timer?.cancel();
    _positionStream?.cancel();
    
    // Save to history
    if (_distance > 0) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.addMovementSession(
        _isShuffle ? 'Shuffle' : 'Walk',
        _distance,
        _duration.inSeconds,
      );
    }

    setState(() {
      _isTracking = false;
      _lastPosition = null;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("PATROL LOGGED")));
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final bool isOps = appState.isOnOps;

    return Scaffold(
      appBar: AppBar(title: const Text("TACTICAL MOVEMENT")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isOps && _isShuffle)
             Container(
              color: Colors.orange,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: const Text("NOTICE: ON OPS. Low impact Patrol recommended.", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          const SizedBox(height: 20),
          // Mode Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("PATROL (WALK)", style: TextStyle(fontWeight: !_isShuffle ? FontWeight.bold : FontWeight.normal)),
              Switch(
                value: _isShuffle,
                onChanged: _isTracking ? null : (val) => setState(() => _isShuffle = val),
              ),
              Text("SHUFFLE (JOG)", style: TextStyle(fontWeight: _isShuffle ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
          if (_isShuffle)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Instruction: Low-impact, short-stride. Feet barely clear ground. No bouncing.",
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),
          
          const SizedBox(height: 50),
          
          // Stats
          Text(
            (_distance / 1609.34).toStringAsFixed(2), // Meters to Miles
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
          ),
          const Text("MILES", style: TextStyle(letterSpacing: 2)),
          
          const SizedBox(height: 20),
          
          Text(
            _formatDuration(_duration),
            style: const TextStyle(fontSize: 40, fontFamily: 'Monospace'),
          ),
          const Text("DURATION", style: TextStyle(letterSpacing: 2)),
          
          const SizedBox(height: 50),
          
          // Controls
          if (!_isTracking)
            ElevatedButton(
              onPressed: _startTracking,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                backgroundColor: Colors.green[800],
              ),
              child: const Text("START MISSION"),
            )
          else
            ElevatedButton(
              onPressed: _stopTracking,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                backgroundColor: Colors.red[900],
              ),
              child: const Text("END MISSION"),
            ),
        ],
      ),
    );
  }
}
