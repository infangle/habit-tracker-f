import 'package:flutter/material.dart';

class ProgressSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Weekly Progress Chart.', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
