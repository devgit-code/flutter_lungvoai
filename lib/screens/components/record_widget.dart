// record_widget.dart
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordWidget extends StatefulWidget {
  final String taskTitle;
  final Function(String?) onSubmit;

  RecordWidget({required this.taskTitle, required this.onSubmit});

  @override
  _RecordWidgetState createState() => _RecordWidgetState();
}

class _RecordWidgetState extends State<RecordWidget> {
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool _isRecording = false;
  bool _isFinish = false;
  String? _filePath;
  double _recordDuration = 0;
  static const int _maxDuration = 120;
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

  Future<void> _initializeRecorder() async {
    await _audioRecorder.openRecorder();
    await _audioRecorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future<bool> _requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> _startRecording() async {
    if (await _requestPermission()) {
      final directory = Directory.systemTemp;
      final fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.wav';
      _filePath = '${directory.path}/$fileName';

      await _audioRecorder.startRecorder(
        toFile: _filePath,
        codec: Codec.pcm16WAV,
      );
      setState(() {
        _isRecording = true;
        _recordDuration = 0;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordDuration++;
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

  Future<void> _deleteRecording() async {
    if (_filePath != null && File(_filePath!).existsSync()) {
      await File(_filePath!).delete();
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

  void _submitRecording() {
    if (_filePath != null && File(_filePath!).existsSync()) {
      widget.onSubmit(_filePath); // Pass the file path back to the parent
      setState(() {
        _isFinish = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No recording to submit!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16.0),
        Text(
          widget.taskTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 24),
        _buildProgressBar(),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRoundButton(
              _isRecording ? "STOP" : "RECORD",
              onPressed: _isFinish ? null : () {
                if (_isRecording) {
                  _stopRecording();
                } else {
                  _startRecording();
                }
              },
            ),
            _buildRoundButton("DELETE", onPressed: !_isFinish || _isRecording ? null : _deleteRecording),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[200],
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
          onPressed: !_isFinish || _isRecording ? null : _submitRecording,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "NEXT",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              if (_isRecording)
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
        const SizedBox(height: 24),
      ],
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
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
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
