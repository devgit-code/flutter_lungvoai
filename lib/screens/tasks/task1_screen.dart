import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:voicelung/screens/tasks_screen.dart';

class Task1Page extends StatefulWidget {
  @override
  _Task1PageState createState() => _Task1PageState();
}

class _Task1PageState extends State<Task1Page> {
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool _isRecording = false; // Track if recording is in progress
  String? _filePath; // Path to the recorded file

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  @override
  void dispose() {
    _audioRecorder.closeRecorder();
    super.dispose();
  }

  /// Initialize the FlutterSoundRecorder
  Future<void> _initializeRecorder() async {
    await _audioRecorder.openRecorder();
    await _audioRecorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  /// Request microphone permission
  Future<bool> _requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Start recording
  Future<void> _startRecording() async {
    debugPrint('started');
    if (await _requestPermission()) {
      final directory = Directory.systemTemp; // Temporary directory
      final fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.wav';
      _filePath = '${directory.path}/$fileName';

      await _audioRecorder.startRecorder(
        toFile: _filePath,
        codec: Codec.pcm16WAV,);
      setState(() {
        _isRecording = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required!')),
      );
    }
  }

  /// Stop recording
  Future<void> _stopRecording() async {
    if (_isRecording) {
      await _audioRecorder.stopRecorder();
      setState(() {
        _isRecording = false;
      });
    }
  }

  /// Delete the recording
  Future<void> _deleteRecording() async {
    if (_filePath != null && File(_filePath!).existsSync()) {
      await File(_filePath!).delete(); // Delete the recorded file
      setState(() {
        _filePath = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording deleted!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No recording to delete!')),
      );
    }
  }

  /// Submit the recording to Firebase Storage
  Future<void> _submitRecording() async {
    if (_filePath != null && File(_filePath!).existsSync()) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('recordings/${DateTime.now().millisecondsSinceEpoch}.wav');

        final uploadTask = storageRef.putFile(File(_filePath!));

        final snapshot = await uploadTask.whenComplete(() {});

        final downloadUrl = await snapshot.ref.getDownloadURL();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording uploaded! URL: $downloadUrl')),
        );

        // Optionally delete the local file after upload
        await File(_filePath!).delete();
        setState(() {
          _filePath = null;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading file: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No recording to submit!')),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              "Press 'record' below and cough 10 times. Please do so in a quiet environment. Then press 'stop'.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24.0),
            const Divider(),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRoundButton(
                  _isRecording ? "STOP" : "RECORD",
                  onPressed: () {
                    if (_isRecording) {
                      _stopRecording();
                    } else {
                      _startRecording();
                    }
                  },
                ),
                _buildRoundButton("DELETE", onPressed: _deleteRecording),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[200],
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),

              onPressed: _submitRecording,
              child: const Text(
                "SUBMIT",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundButton(String text, {required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[200],
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}