import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:voicelung/screens/tasks_screen.dart';

class Task4Page extends StatefulWidget {
  @override
  _Task4PageState createState() => _Task4PageState();
}

class _Task4PageState extends State<Task4Page> {
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool _isRecording = false; // Track if recording is in progress
  bool _isFinish = false; // Track if recording is in progress
  bool _isUploading = false; // Track if recording is in progress
  String? _filePath; // Path to the recorded file
  double _recordDuration = 0;
  bool _initialRecordingPhase = true;
  static const int _maxDuration = 120; // 2 minutes
  static const int _initialPhaseDuration = 3; // 3 seconds
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  @override
  void dispose() {
    _audioRecorder.closeRecorder();
    _timer?.cancel();
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
    if (await _requestPermission()) {
      final directory = Directory.systemTemp; // Temporary directory
      final fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.wav';
      _filePath = '${directory.path}/$fileName';

      await _audioRecorder.startRecorder(
        toFile: _filePath,
        codec: Codec.pcm16WAV,);
      setState(() {
        _isRecording = true;
        _recordDuration = 0;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordDuration++;
          if (_recordDuration >= _initialPhaseDuration) {
            _initialRecordingPhase = false;
          }
          if (_recordDuration >= _maxDuration) {
            _stopRecording();
          }
        });
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
      _timer?.cancel();
      setState(() {
        _isFinish = true;
        _isRecording = false;
        _recordDuration = 0;
      });
    }
  }

  /// Delete the recording
  Future<void> _deleteRecording() async {
    if (_filePath != null && File(_filePath!).existsSync()) {
      await File(_filePath!).delete(); // Delete the recorded file
      setState(() {
        _filePath = null;
        _isFinish = false;
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
        setState(() {
          _isUploading = true; // Set to true when the upload starts
        });

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('recordings/${DateTime.now().millisecondsSinceEpoch}.wav');

        final uploadTask = storageRef.putFile(File(_filePath!));

        final snapshot = await uploadTask.whenComplete(() {});

        final downloadUrl = await snapshot.ref.getDownloadURL();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording uploaded!')), //URL: $downloadUrl
        );

        // Optionally delete the local file after upload
        await File(_filePath!).delete();
        setState(() {
          _filePath = null;
          _isFinish = false;
          _isUploading = false;
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

  // String _formatDuration(double seconds) {
  //   final duration = Duration(seconds: seconds.toInt());
  //   return DateFormat('mm:ss').format(DateTime(0).add(duration));
  // }

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
              "Please read the Rainbow Passage now. Once done press 'stop'.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24.0),
            _buildProgressBar(),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRoundButton(
                  _isRecording ? "STOP" : "RECORD",
                  onPressed: (_isFinish == true) ? null : () {
                    if (_isRecording) {
                      _stopRecording();
                    } else {
                      _startRecording();
                    }
                  },
                ),
                _buildRoundButton("DELETE", onPressed: (_isFinish == false || _isUploading) ? null : _deleteRecording),
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

              onPressed: (_isFinish == false || _isUploading) ? null : _submitRecording,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "SUBMIT",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10), // Adds some space between the text and spinner
                  if (_isUploading) // Show spinner only when
                    const SizedBox(
                      height: 16, // Fixed height for the spinner
                      width: 16,  // Fixed width for the spinner
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Spinner color
                        strokeWidth: 2, // Spinner thickness
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundButton(String text, {VoidCallback? onPressed}) {
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

  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      value: _recordDuration / _maxDuration,
      backgroundColor: Colors.grey,
      color: Colors.blue,
    );
  }
}