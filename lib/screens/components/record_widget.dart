import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RecorderWidget extends StatefulWidget {
  /// Instruction text to display above the buttons (e.g., say "/a:/" or "/o:/").
  final String instructionText;

  /// Callback to be invoked after a successful recording upload.
  /// In your multi-step page, this will trigger "go to next step" or "go home" logic.
  final VoidCallback onSubmit;

  const RecorderWidget({
    Key? key,
    required this.instructionText,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _RecorderWidgetState createState() => _RecorderWidgetState();
}

class _RecorderWidgetState extends State<RecorderWidget> {
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _filePath;

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
    debugPrint('Recording started');
    if (await _requestPermission()) {
      final directory = Directory.systemTemp; // or use getTemporaryDirectory() from path_provider
      final fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.wav';
      _filePath = '${directory.path}/$fileName';

      await _audioRecorder.startRecorder(
        toFile: _filePath,
        codec: Codec.pcm16WAV,
      );
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
      await File(_filePath!).delete();
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

  /// Upload to Firebase Storage & invoke onSubmit
  Future<void> _submitRecording() async {
    if (_filePath != null && File(_filePath!).existsSync()) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('recordings/${DateTime.now().millisecondsSinceEpoch}.wav');

        final uploadTask = storageRef.putFile(File(_filePath!));
        await uploadTask.whenComplete(() {}); // Wait for upload completion

        final downloadUrl = await storageRef.getDownloadURL();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording uploaded! URL: $downloadUrl')),
        );

        // Optionally delete the local file after upload
        await File(_filePath!).delete();
        setState(() {
          _filePath = null;
        });

        // Trigger the onSubmit callback to move to the next step (or go home)
        widget.onSubmit();
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
    return Column(
      children: [
        const SizedBox(height: 16.0),
        // The instruction text
        Text(
          widget.instructionText,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 24.0),
        const Divider(),
        const SizedBox(height: 24.0),

        // Row of buttons: RECORD/STOP + DELETE
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

        // The Submit button
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
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
