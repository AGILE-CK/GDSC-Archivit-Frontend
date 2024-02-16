// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async'; // 이 줄을 추가해주세요.
import 'package:flutter/material.dart';
import 'password.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert'; // Import JSON codec

class RecordingScreen extends StatefulWidget {
  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool isPlaying = false;
  int timerValue = 0;
  bool isRecording = false; // a variable to track recording state
  late Timer _timer; // Timer 변수를 선언합니다.
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _recorder.openAudioSession();
    _isRecorderInitialized = true;
  }

  void _startRecordingLoop() async {
    if (!_isRecorderInitialized) return;
    const int recordingDuration = 5; // Record 5 seconds chunks
    while (isRecording) { // isRecording should be a global state to control recording loop
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
      
      await _recorder.startRecorder(
        toFile: filePath,
        codec: Codec.aacADTS,
      );
      await Future.delayed(Duration(seconds: recordingDuration));
      await _recorder.stopRecorder();

      _sendFileToBackend(filePath);
    }
  }

void _sendFileToBackend(String filePath) async {
  var request = http.MultipartRequest(
    'POST', Uri.parse('http://104.154.58.103:8080/violent-speech-detection/')
  )..files.add(await http.MultipartFile.fromPath('file', filePath));
  
  var response = await request.send();
  
  if (response.statusCode == 200) {
    // Parse the response
    String responseBody = await response.stream.bytesToString();
    Map<String, dynamic> parsedResponse = jsonDecode(responseBody);

    if (parsedResponse["violence_status"] == "Violent Situation Detected") {
      // Start audio recording to save evidence
      setState(() {
        isRecording = false; // Stop the loop
        // Add the trigger recording
        if (!isPlaying) {
          togglePlay();
        }
      });
    }
    // If "Non-Violent Situation", just continue with the loop in _startRecordingLoop()
  } else {
    // Handle error or invalid response
    print("Error: Server returned an error status code.");
  }
  
  // Delete the temporary file
  File(filePath).delete();
}

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
                      Text(
                        'Archivit', // Archivit 텍스트를 유지합니다.
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                          letterSpacing: 1.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showSavePopup(context);
                        },
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
                    fontSize: 50.0, // 타이머 숫자의 크기 조절
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isRecording = !isRecording;
                          if (isRecording) {
                            // Start the recording loop
                            _startRecordingLoop();
                          } else {
                            // Stop recording if currently in progress
                            _recorder.stopRecorder();
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0, 
                          horizontal: isRecording ? 32.0 : 16.0, // Increase horizontal padding
                        ),
                        decoration: BoxDecoration(
                          color: isRecording ? Colors.deepPurple : Colors.purpleAccent, // Change color when recording
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: isRecording ? Colors.deepPurple[700]!.withOpacity(0.6) : Colors.purpleAccent.withOpacity(0.3),
                              spreadRadius: isRecording ? 4 : 1,
                              blurRadius: isRecording ? 10 : 2,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // to wrap content in the row
                          children: [
                            Icon(
                              Icons.mic, // Microphone icon
                              color: Colors.white,
                              size: 24.0,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              'Auto Record',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: 20), // Space between buttons
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.stop : Icons.play_arrow,
                        color: Colors.white,
                        size: 50.0,
                      ),
                      onPressed: () {
                        togglePlay();
                      },
                    ),
                  ],
                ),
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

  void _stopTimer() {
    _timer.cancel();
    setState(() {
      timerValue = 0;
    });
  }

  void togglePlay() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _startTimer();
      } else {
        _stopTimer();
      }
    });
  }

  void _showSavePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Center(child: Text("Save")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Do you want to save your recording?"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "No",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
