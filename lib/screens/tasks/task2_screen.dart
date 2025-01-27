import 'package:flutter/material.dart';
import 'package:voicelung/screens/tasks_screen.dart';
import 'package:voicelung/screens/components/record_widget.dart';  // Import the Task1Page component

class Task2Page extends StatefulWidget {
  @override
  _Task2PageState createState() => _Task2PageState();
}

class _Task2PageState extends State<Task2Page> {
  int currentStep = 0;

  final List<String> taskTitles = [
    "Press 'record' below and say '/a:/' 2-3 times as in word 'art'. Then press 'stop'.",
    "Press 'record' below and say 'eeee....' 2-3 times as in eel. Then press 'stop'.",
    "Press 'record' below and say 'ii....' 2-3 times as in ice. Then press 'stop'.",
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
                    onSubmit: (String? filePath) {
                      _moveToNextTask(filePath); // Accumulate file paths
                    },
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
