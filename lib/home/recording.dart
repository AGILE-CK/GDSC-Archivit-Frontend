// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async'; // 이 줄을 추가해주세요.
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:gdsc/provider/make_file_page_provider.dart';
import 'package:gdsc/service/backend_api.dart';
import 'package:gdsc/service/get_default_directory.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../service/token_function.dart';
import 'dart:convert';

class RecordingScreen extends StatefulWidget {
  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool isPlaying = false;
  int timerValue = 0;
  late Timer _timer;
  bool isRecording = false;
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;
  String? _recordFilePath;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    try {
      // var status = await Permission.microphone.request();
      // if (status != PermissionStatus.granted) {
      //   print("Microphone permission not granted");
      //   return;
      // }
      await _recorder.openAudioSession();
      setState(() => _isRecorderInitialized = true);
    } catch (e) {
      print('Failed to open audio session: $e');
    }
  }

  void togglePlay(String path) async {
    if (!_isRecorderInitialized) {
      print('Recorder not initialized');
      return;
    }

    // Start recording
    if (!isRecording) {
      Directory tempDir = await createUserDataDirectory();

      String filePath = '${tempDir.path}/$path.m4a';
      try {
        await _recorder.startRecorder(
          toFile: filePath,
          codec: Codec.aacMP4,
        );
        _recordFilePath = filePath;
        _startTimer();
        setState(() {
          isRecording = true; // Now recording
          isPlaying = true; // Update the playing state if necessary
          isPaused = false; // Reset paused state
        });
      } catch (e) {
        print('Failed to start recording: $e');
      }
    } else if (isRecording && !isPaused) {
      // Pause recording
      try {
        await _recorder.pauseRecorder();
        _timer.cancel(); // Stop the timer but do not reset timerValue
        setState(() {
          isPaused = true; // Recording is now paused
          isPlaying = false; // Update the playing state if necessary
        });
      } catch (e) {
        print('Failed to pause recording: $e');
      }
    } else if (isRecording && isPaused) {
      // Resume recording
      try {
        await _recorder.resumeRecorder();
        _startTimer(); // Resume the timer without resetting timerValue
        setState(() {
          isPaused = false; // Recording has resumed
          isPlaying = true; // Update the playing state if necessary
        });
      } catch (e) {
        print('Failed to resume recording: $e');
      }
    }
  }

  void _cancelRecording() async {
    if (_recorder.isRecording || isPaused) {
      await _recorder.stopRecorder();
      if (_recordFilePath != null) {
        final file = File(_recordFilePath!);
        if (await file.exists()) {
          await file.delete(); // Delete the recorded file
        }
      }
      _timer.cancel(); // Stop the timer
      setState(() {
        isRecording = false;
        isPlaying = false;
        isPaused = false;
        timerValue = 0; // Reset timer value
        _recordFilePath = null; // Reset the file path
      });
    }
  }

  // Future<void> _initRecorderSecond() async {
  //   var status = await Permission.microphone.request();
  //   if (status != PermissionStatus.granted) {
  //     // Handle permission denial
  //     print('Microphone permission not granted');
  //     return;
  //   }
  //   await _recorder.openAudioSession();
  //   setState(() => _isRecorderInitialized = true);
  // }

  @override
  void dispose() {
    _recorder.closeAudioSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(left: 16.0, top: 44.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (isRecording) {
                            // Cancel recording logic
                            _cancelRecording();
                          } else {
                            // Navigate back logic
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          isRecording ? 'Cancel' : 'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'Archivit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                          letterSpacing: 1.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showSavePopup(context),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0), // 위아래 margin 추가
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Transform.translate(
                        offset: Offset(0, 50), // Y 방향으로 50만큼 이동
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            SizedBox(width: 4.0), // 아이콘과 텍스트 사이 간격 조절
                            GestureDetector(
                              onTap: () {
                                // "Type the name" 텍스트를 누르면 해당 텍스트에 포커스를 줍니다.
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              child: Text(
                                '위치',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40), // 텍스트와 아이콘 사이의 간격 조절
                      Transform.translate(
                        offset: Offset(0, 20), // Y 방향으로 20만큼 이동
                        child: GestureDetector(
                          onTap: () {
                            // "Type the name" 텍스트를 누르면 해당 텍스트에 포커스를 줍니다.
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Center(
                            child: TextField(
                              textAlign: TextAlign.center, // 텍스트를 가운데로 맞춥니다.
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Type the name',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none, // 텍스트 필드의 외곽선을 없앱니다.
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _printDuration(Duration(seconds: timerValue)),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0, // Make the timer number smaller
                  ),
                ),
                SizedBox(height: 80.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<MakeFilePageProvider>(
                        builder: (context, makeTextFilePageProvider, child) {
                      return GestureDetector(
                        onTap: () {
                          togglePlay(makeTextFilePageProvider.fullPath);
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: isRecording ? 32.0 : 16.0,
                          ),
                          decoration: BoxDecoration(
                            color: isRecording
                                ? Colors.deepPurple
                                : Colors.purpleAccent,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: isRecording
                                    ? Colors.deepPurple[700]!.withOpacity(0.6)
                                    : Colors.purpleAccent.withOpacity(0.3),
                                spreadRadius: isRecording ? 4 : 1,
                                blurRadius: isRecording ? 10 : 2,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPlaying || isPaused ? Icons.stop : Icons.mic,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                isPlaying
                                    ? 'Recording'
                                    : isPaused
                                        ? 'Paused'
                                        : 'Record',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 25.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        timerValue++;
      });
    });
  }

  void _showSavePopup(BuildContext context) async {
    // Check if recording is active and pause it before showing the dialog
    if (isRecording && !isPaused) {
      await _recorder.pauseRecorder();
      _timer.cancel(); // Stop the timer
      setState(() {
        isPaused = true;
        isPlaying = false;
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Center(child: Text("Save")),
          content: Text("Do you want to save your recording?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog

                if (isPaused) {
                  // Optionally, resume recording or handle as needed
                }
              },
              child: Text(
                "No",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              width: 90, // Adjusted for formatting
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // Proceed with save operation
                await _saveRecording();
                Get.back();
              },
              child: Text(
                "Yes",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveRecording() async {
    if (_recordFilePath == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No recording to save.')));
      return;
    }

    try {
      var response = await uploadRecording(_recordFilePath!);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Recording uploaded successfully.')));
        // Assume recording is no longer needed and can be deleted
        final file = File(_recordFilePath!);

        // if (await file.exists()) {
        //   await file.delete(); // Delete the recorded file if saved successfully
        // }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload recording.')));
      }
    } catch (e) {
      print('Error saving recording: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error saving recording.')));
    } finally {
      // Resetting the recording state for a new recording
      await _recorder.stopRecorder(); // Ensure the recorder is stopped
      _timer.cancel(); // Stop the timer
      setState(() {
        isRecording = false;
        isPlaying = false;
        isPaused = false;
        timerValue = 0; // Reset timer value
        _recordFilePath = null; // Clear the file path for a new recording
      });
    }
  }
}
