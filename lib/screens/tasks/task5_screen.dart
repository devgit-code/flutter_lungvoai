import 'package:flutter/material.dart';
import 'package:voicelung/screens/tasks_screen.dart';
import 'package:voicelung/screens/components/record_widget.dart';  // Import the Task1Page component

class Task5Page extends StatefulWidget {
  @override
  _Task5PageState createState() => _Task5PageState();
}

class _Task5PageState extends State<Task5Page> {
  int currentStep = 0;

  final List<String> taskTitles = [
    "Start recording and please Describe the room you are in",
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
