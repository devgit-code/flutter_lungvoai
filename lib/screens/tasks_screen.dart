import 'package:flutter/material.dart';
import 'package:voicelung/screens/tasks/task1_screen.dart';
import 'package:voicelung/screens/tasks/task2_screen.dart';
import 'package:voicelung/screens/tasks/task3_screen.dart';
import 'package:voicelung/screens/tasks/task4_screen.dart';
import 'package:voicelung/screens/tasks/task5_screen.dart';
import 'package:voicelung/screens/tasks/task6_screen.dart';
import 'package:voicelung/screens/tasks/task7_screen.dart';
import 'package:voicelung/screens/tasks/task8_screen.dart';

class TaskPage extends StatelessWidget {
  final String userName; // Accept the username as a parameter

  const TaskPage({Key? key, required this.userName}) : super(key: key);

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
            _buildTaskButton("TASK1 - COUGH", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Task1Page(userName: userName)),
              );
            }),
            // const SizedBox(height: 16.0),
            // _buildTaskButton("TASK2 - VOWEL", () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Task2Page()),
            //   );
            // }),
            // const SizedBox(height: 16.0),
            // _buildTaskButton("TASK3 - BREATHE/SPIRO", () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Task3Page()),
            //   );
            // }),
            // const SizedBox(height: 16.0),
            // _buildTaskButton("TASK4 - RAINBOW", () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Task4Page()),
            //   );
            // }),
            // const SizedBox(height: 16.0),
            // _buildTaskButton("TASK5 - DESCRIBE STH", () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Task5Page()),
            //   );
            // }),
            // const SizedBox(height: 16.0),
            // _buildTaskButton("TASK6 - READ 3 SENTENCES", () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Task6Page()),
            //   );
            // }),
            // const SizedBox(height: 16.0),
            // _buildTaskButton("TASK7 - DESCRIBE PIC", () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Task7Page()),
            //   );
            // }),
            // const SizedBox(height: 16.0),
            // _buildTaskButton("TASK8 - READ ACT/NO-ACT TEXT", () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Task8Page()),
            //   );
            // }),
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