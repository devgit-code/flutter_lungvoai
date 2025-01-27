import 'package:flutter/material.dart';
import 'package:voicelung/screens/tasks_screen.dart';
import 'package:voicelung/screens/components/record_widget.dart';  // Import the Task1Page component

class Task6Page extends StatefulWidget {
  @override
  _Task6PageState createState() => _Task6PageState();
}

class _Task6PageState extends State<Task6Page> {
  int currentStep = 0;

  final List<String> taskTitles = [
    "You will be asked to speak three sentences one by one. Press 'record' below and say 'London is the capital and largest city of England and the United Kingdom.'. Then press 'stop'.",
    "Press 'record' below and say 'The weather today is sunny, with lots of wind and a lot of clouds in the sky which will bring heavy rain and thunderstorms in the afternoon.'. Then press 'stop'.",
    "Press 'record' below and say 'London is the capital and largest city of England and the United Kingdom.'. Then press 'stop'.",
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
