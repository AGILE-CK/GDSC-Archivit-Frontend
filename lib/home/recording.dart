import 'dart:async'; // 이 줄을 추가해주세요.
import 'package:flutter/material.dart';
import 'password.dart';

class RecordingScreen extends StatefulWidget {
  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool isPlaying = false;
  int timerValue = 0;
  late Timer _timer; // Timer 변수를 선언합니다.

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
                SizedBox(
                  width: 60.0, // 아이콘의 너비 지정
                  height: 100.0, // 아이콘의 높이 지정
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.stop : Icons.play_arrow,
                      color: Colors.white,
                      size: 50.0, // 아이콘 크기 조정
                    ),
                    onPressed: () {
                      setState(() {
                        isPlaying = !isPlaying;
                        if (isPlaying) {
                          _startTimer();
                        } else {
                          _stopTimer();
                        }
                      });
                    },
                  ),
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
