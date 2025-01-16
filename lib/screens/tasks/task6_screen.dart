import 'package:flutter/material.dart';
import 'package:voicelung/screens/tasks_screen.dart';
import 'package:voicelung/screens/components/record_widget.dart';  // Import the Task1Page component

class Task6Page extends StatefulWidget {
  @override
  _Task6PageState createState() => _Task6PageState();
}

class _Task6PageState extends State<Task6Page> {
  int currentStep = 0; // Track current step (0: letter, 1: number, 2: sentence)

  // Define task titles for each step
  final List<String> taskTitles = [
    "You will be asked to speak three sentences one by one. Press 'record' below and say 'London is the capital and largest city of England and the United Kingdom.'. Then press 'stop'.",
    "Press 'record' below and say 'The weather today is sunny, with lots of wind and a lot of clouds in the sky which will bring heavy rain and thunderstorms in the afternoon.'. Then press 'stop'.",
    "Press 'record' below and say 'London is the capital and largest city of England and the United Kingdom.'. Then press 'stop'.",
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
