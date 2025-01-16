import 'package:flutter/material.dart';
import 'package:voicelung/screens/tasks_screen.dart';
import 'package:voicelung/screens/components/record_widget.dart';  // Import the Task1Page component

class Task2Page extends StatefulWidget {
  @override
  _Task2PageState createState() => _Task2PageState();
}

class _Task2PageState extends State<Task2Page> {
  int currentStep = 0; // Track current step (0: letter, 1: number, 2: sentence)

  // Define task titles for each step
  final List<String> taskTitles = [
    "Press 'record' below and say '/a:/' 2-3 times as in word 'art'. Then press 'stop'.",
    "Press 'record' below and say 'eeee....' 2-3 times as in eel. Then press 'stop'.",
    "Press 'record' below and say 'ii....' 2-3 times as in ice. Then press 'stop'.",
    "Press 'record' below and say 'o....' 2-3 times as in oak. Then press 'stop'.",
    "Press 'record' below and say 'u....' 2-3 times as in unicorn. Then press 'stop'.",
    "Press 'record' below and say '/u:/..' 2-3 times as in goose. Then press 'stop'.",
    "Press 'record' below and say '/ɔ:/..' 2-3 times as in thought. Then press 'stop'.",
  ];

  // Function to move to the next task after submission
  void _moveToNextTask() {
    if (currentStep < taskTitles.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TaskPage()), // Go to TaskPage
      );
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
