import 'package:flutter/material.dart';
import 'package:voicelung/screens/tasks_screen.dart';
import 'package:voicelung/screens/components/record_widget.dart';  // Import the Task1Page component

class Task8Page extends StatefulWidget {
  @override
  _Task8PageState createState() => _Task8PageState();
}

class _Task8PageState extends State<Task8Page> {
  int currentStep = 0;

  // Define task titles for each step
  final List<String> taskTitles = [
    "Press 'record' below and read the text with action words. Then press 'stop'.",
    "Press 'record' below and read the text with non-action words. Then press 'stop'.",
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
      Navigator.pop(context, filePaths); // Pass the array of file paths
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
                Expanded(
                  child: RecordWidget(
                    taskTitle: taskTitles[currentStep],
                    onSubmit: _moveToNextTask,
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
