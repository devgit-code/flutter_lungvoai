import 'package:flutter/material.dart';
import 'package:voicelung/screens/tasks_screen.dart';
import 'package:voicelung/screens/components/record_widget.dart';  // Import the Task1Page component

class Task3Page extends StatefulWidget {
  @override
  _Task3PageState createState() => _Task3PageState();
}

class _Task3PageState extends State<Task3Page> {
  int currentStep = 0;

  final List<String> taskTitles = [
    "Press 'record' below. Take a deep breath (with nose as much as you can) and slowly exhale (from mouth) making sure you empty your lungs fully. Please do so in a quiet environment. Then press 'stop'.",
    "Press 'record' below. Take a deep breath (with nose as much as you can) and exhale as quickly and forcefully as you can (from mouth) making sure you empty your lungs fully. Please do so in a quiet environment. Do this three times. Then press 'stop'.",
  ];

  List<String?> filePaths = [];

  void _moveToNextTask(String? filePath) {
    if (filePath != null) {
      filePaths.add(filePath);
    }

    if (currentStep < taskTitles.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      Navigator.pop(context, filePaths);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'LUNGVOAI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded( // Ensures RecordWidget takes available space without causing layout issues
                  child: RecordWidget(
                    taskTitle: taskTitles[currentStep],
                    onSubmit: _moveToNextTask, // Move to next task after submission
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
