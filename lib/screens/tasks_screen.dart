import 'package:flutter/material.dart';
import 'package:voicelung/screens/tasks/task1_screen.dart';
import 'package:voicelung/screens/tasks/task2_screen.dart';

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
              // Add navigation for Task3Page here
            }),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK4 - RAINBOW", () {
              // Add navigation for Task4Page here
            }),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK5 - DESCRIBE STH", () {
              // Add navigation for Task5Page here
            }),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK6 - READ 3 SENTENCES", () {
              // Add navigation for Task6Page here
            }),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK7 - DESCRIBE PIC", () {
              // Add navigation for Task7Page here
            }),
            const SizedBox(height: 16.0),
            _buildTaskButton("TASK8 - READ ACT/NO-ACT TEXT", () {
              // Add navigation for Task8Page here
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
//
// class Task1Page extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: const Text(
//           'LUNGVOAI',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const SizedBox(height: 16.0),
//             const Text(
//               "Press 'record' below and cough 10 times. Please do so in a quiet environment. Then press 'stop'.",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             const SizedBox(height: 24.0),
//             const Divider(),
//             const SizedBox(height: 24.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildRoundButton("RECORD", onPressed: () {
//                   // Add functionality for recording
//                 }),
//                 _buildRoundButton("DELETE", onPressed: () {
//                   // Add functionality for deleting recording
//                 }),
//               ],
//             ),
//             const Spacer(),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue[200],
//                 foregroundColor: Colors.black,
//                 padding: const EdgeInsets.symmetric(vertical: 16.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(24.0),
//                 ),
//               ),
//               onPressed: () {
//                 // Add functionality for submitting
//               },
//               child: const Text(
//                 "SUBMIT",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24.0),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRoundButton(String text, {required VoidCallback onPressed}) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.blue[200],
//         foregroundColor: Colors.black,
//         padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(32.0),
//         ),
//       ),
//       onPressed: onPressed,
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }