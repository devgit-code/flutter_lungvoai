import 'package:flutter/material.dart';
import 'package:voicelung/screens/tasks/task1_screen.dart';
import 'package:voicelung/screens/tasks/task2_screen.dart';
import 'package:voicelung/screens/tasks/task3_screen.dart';
import 'package:voicelung/screens/tasks/task4_screen.dart';
import 'package:voicelung/screens/tasks/task5_screen.dart';
import 'package:voicelung/screens/tasks/task6_screen.dart';
import 'package:voicelung/screens/tasks/task7_screen.dart';
import 'package:voicelung/screens/tasks/task8_screen.dart';
import 'package:voicelung/user_data.dart';

class TaskPage extends StatelessWidget {
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
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Displaying the User's ID (from UserData)
            Text(
              'Welcome, ${UserData.idName}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),

            // Task buttons
            _buildTaskButton("TASK1 - COUGH", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Task1Page()),
              );
            }),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK2 - VOWEL", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Task2Page()),
              );
            }),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK3 - BREATHE/SPIRO", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Task3Page()),
              );
            }),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK4 - RAINBOW", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Task4Page()),
              );
            }),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK5 - DESCRIBE STH", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Task5Page()),
              );
            }),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK6 - READ 3 SENTENCES", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Task6Page()),
              );
            }),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK7 - DESCRIBE PIC", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Task7Page()),
              );
            }),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK8 - READ ACT/NO-ACT TEXT", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Task8Page()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskButton(String taskText, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        taskText,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
