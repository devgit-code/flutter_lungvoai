import 'package:flutter/material.dart';
import 'package:voicelung/main.dart';
import 'package:voicelung/screens/tasks/task1_screen.dart';
import 'package:voicelung/screens/tasks/task2_screen.dart';
import 'package:voicelung/screens/tasks/task3_screen.dart';
import 'package:voicelung/screens/tasks/task4_screen.dart';
import 'package:voicelung/screens/tasks/task5_screen.dart';
import 'package:voicelung/screens/tasks/task6_screen.dart';
import 'package:voicelung/screens/tasks/task7_screen.dart';
import 'package:voicelung/screens/tasks/task8_screen.dart';
import 'package:voicelung/user_data.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  // List to track the completion state of tasks (true if completed)
  List<bool> taskCompletion = List.generate(8, (index) => false);

  // Function to mark a task as completed
  void markTaskCompleted(int taskIndex) {
    setState(() {
      taskCompletion[taskIndex] = true;
    });
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
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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

            // Task buttons (Task1 to Task8)
            _buildTaskButton("TASK1 - COUGH", 0, Task1Page()),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK2 - VOWEL", 1, Task2Page()),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK3 - BREATHE/SPIRO", 2, Task3Page()),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK4 - RAINBOW", 3, Task4Page()),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK5 - DESCRIBE STH", 4, Task5Page()),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK6 - READ 3 SENTENCES", 5, Task6Page()),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK7 - DESCRIBE PIC", 6, Task7Page()),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK8 - READ ACT/NO-ACT TEXT", 7, Task8Page()),
            const SizedBox(height: 32.0),

            // Finish Recording Button (Only enabled when all tasks are completed)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              onPressed: _areAllTasksCompleted() ? () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              } : null,  // Disable if not all tasks are completed
              child: const Text(
                'Finish Recording',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _areAllTasksCompleted() {
    return !taskCompletion.contains(false);  // Returns true if no task is incomplete
  }

  Widget _buildTaskButton(String taskText, int taskIndex, Widget targetPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: taskCompletion[taskIndex] ? Colors.green : Colors.grey[300],
          foregroundColor: taskCompletion[taskIndex] ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        onPressed: () async {
          bool taskCompleted = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          ) ?? false;

          // After navigating back, mark the task as completed
          if (taskCompleted) {
            markTaskCompleted(taskIndex);
          }
        },
        child: Text(
          taskText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
