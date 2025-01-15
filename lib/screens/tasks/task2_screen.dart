import 'package:flutter/material.dart';
import 'package:voicelung/screens/tasks_screen.dart';
import 'package:voicelung/screens/components/record_widget.dart';

class Task2Page extends StatefulWidget {
  const Task2Page({Key? key}) : super(key: key);

  @override
  _Task2PageState createState() => _Task2PageState();
}

class _Task2PageState extends State<Task2Page> {
  // We have 3 steps (for the 3 vowels)
  int _currentStep = 0;

  // Each step has its own instruction text
  final List<String> _vowelInstructions = [
    "Press 'record' below and say '/a:/' 2-3 times (e.g., 'art'). Then press 'stop'.",
    "Press 'record' below and say '/o:/' 2-3 times (e.g., 'dog'). Then press 'stop'.",
    "Press 'record' below and say '/i:/' 2-3 times (e.g., 'eat'). Then press 'stop'.",
  ];

  /// Moves to the next vowel step, or if done, navigate home.
  void _goToNextStep() {
    if (_currentStep < _vowelInstructions.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Last step is done, navigate to home (or tasks_screen)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => TaskPage()),
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        // Show the VowelRecorderWidget for the current step
        child: RecorderWidget(
          instructionText: _vowelInstructions[_currentStep],
          onSubmit: _goToNextStep,
        ),
      ),
    );
  }
}
