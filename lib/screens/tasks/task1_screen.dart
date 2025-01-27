// task1_screen.dart
import 'package:flutter/material.dart';
import 'package:voicelung/screens/components/record_widget.dart';

class Task1Page extends StatefulWidget {
  @override
  _Task1PageState createState() => _Task1PageState();
}

class _Task1PageState extends State<Task1Page> {
  int currentStep = 0;
  final List<String> taskTitles = [
    "Press 'record' below and cough 10 times. Please do so in a quiet environment. Then press 'stop'.",
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
                Expanded(
                  child: RecordWidget(
                    taskTitle: taskTitles[currentStep],
                    onSubmit: (String? filePath) {
                      _moveToNextTask(filePath);
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
