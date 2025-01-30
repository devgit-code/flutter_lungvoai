import 'dart:io';
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
import 'package:firebase_storage/firebase_storage.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<bool> taskCompletion = List.generate(8, (index) => false);
  List<List<String?>> taskFilePaths = List.generate(8, (index) => []);

  bool _isUploading = false;

  List<String> taskNames = [
    "task_1_cough.wav",
    "task_2_vowel_a.wav",
    "task_2_vowel_e.wav",
    "task_2_vowel_i.wav",
    "task_3_breath.wav",
    "task_3_spiro.wav",
    "task_4_rainbow.wav",
    "task_5_describe.wav",
    "task_6_sentence_1.wav",
    "task_6_sentence_2.wav",
    "task_6_sentence_3.wav",
    "task_7_describe_pic.wav",
    "task_8_act_text.wav",
    "task_8_non-act_text.wav",
  ];

  // Function to mark a task as completed and store the file paths
  void markTaskCompleted(int taskIndex, List<String?> filePaths) {
    setState(() {
      taskCompletion[taskIndex] = true;
      taskFilePaths[taskIndex] = filePaths;
    });
  }

  Future<void> _uploadAllRecordings() async {
    setState(() {
      _isUploading = true;
    });

    String baseDirectory = "recordings/${UserData.idName}";

    // Fetch the last record_i
    int nextRecordId = await _getNextRecordId(baseDirectory);
    String newRecordDirectory = "$baseDirectory/record_$nextRecordId";

    List<String?> allFiles = taskFilePaths.expand((files) => files).toList();
    if (allFiles.isNotEmpty) {
      for (int i = 0; i < allFiles.length; i++) {
        String? filePath = allFiles[i];

        if (filePath != null) {
          String taskFileName = taskNames[i];
          String storagePath = "$newRecordDirectory/$taskFileName";
          await _uploadRecording(filePath, storagePath);
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All recordings uploaded successfully!')),
    );
    setState(() {
      _isUploading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  Future<void> _uploadRecording(String filePath, String storagePath) async {
    final storage = FirebaseStorage.instance;

    if (filePath != null) {
      try {
        File file = File(filePath);
        await storage.ref(storagePath).putFile(file);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading file: $e')),
        );
      }
    }
  }

  Future<int> _getNextRecordId(String baseDirectory) async {
    final storage = FirebaseStorage.instance;
    final ListResult result = await storage.ref(baseDirectory).listAll();

    List<int> recordIds = result.prefixes
        .map((ref) => int.tryParse(ref.name.split("_").last) ?? 0)
        .toList();

    return recordIds.isEmpty ? 1 : (recordIds.reduce((a, b) => a > b ? a : b) + 1);
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
            Text(
              'Welcome, ${UserData.idName}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),

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

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              onPressed: _areAllTasksCompleted() && !_isUploading ? () {
                _uploadAllRecordings();
              } : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Finish Recording',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (_isUploading)
                    const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        strokeWidth: 2,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _areAllTasksCompleted() {
    return !taskCompletion.contains(false);
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
          List<String?> filePaths = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );

          if (filePaths.isNotEmpty) {
            markTaskCompleted(taskIndex, filePaths);
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
