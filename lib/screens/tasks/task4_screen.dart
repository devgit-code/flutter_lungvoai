import 'package:flutter/material.dart';
import 'package:voicelung/screens/tasks_screen.dart';
import 'package:voicelung/screens/components/record_widget.dart';  // Import the Task1Page component

class Task4Page extends StatefulWidget {
  @override
  _Task4PageState createState() => _Task4PageState();
}

class _Task4PageState extends State<Task4Page> {
  int currentStep = 0; // Track current step (0: letter, 1: number, 2: sentence)

  // Define task titles for each step
  final List<String> taskTitles = [
    "Please read the Rainbow Passage now. Once done press 'stop'.",
  ];

  // Function to move to the next task after submission
  void _moveToNextTask() {
    if (currentStep < taskTitles.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      Navigator.pop(context, true);
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
