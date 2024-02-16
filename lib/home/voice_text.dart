import 'package:flutter/material.dart';

enum PlaybackSpeed { normal, doubleSpeed, tripleSpeed }

class VoiceTextScreen extends StatefulWidget {
  @override
  _VoiceTextScreenState createState() => _VoiceTextScreenState();
}

class _VoiceTextScreenState extends State<VoiceTextScreen> {
  bool isPlaying = false;
  PlaybackSpeed playbackSpeed = PlaybackSpeed.normal;

  // 대상들의 대화를 나타내는 리스트
  List<String> conversation = [
    "A: Hi there!",
    "B: Hello!",
    "A: How are you?",
    "C: I'm good, thanks for asking.",
    "A: That's great to hear!",
    "B: Yeah, how about you?",
    "C: I'm doing well too.",
    "A: That's good."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 16.0, top: 44.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Archivit',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'May 13, 2021',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.0),
                  Text(
                    'ClassRoom',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 26.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'AI summary note',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.0),
                  Text(
                    '⚠️ The provided summary is based on the AI understanding of the recording situation. It is offered for convenience only and does not hold any legal effect or responsibility.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.0),
                ],
              ),
            ),
            SizedBox(height: 10.0), // 텍스트와 대화 텍스트 사이 간격 조절
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlueAccent),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0), // 텍스트 위아래 여백 추가
                  Text(
                    'This is a long AI summary text. It will dynamically adjust the size of the box based on the length of the text. This ensures that the box expands vertically as the text gets longer.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0), // 대화 텍스트와 BottomBar 사이 간격 조절
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: conversation.map((text) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 10.0, // 동그라미 크기 조절
                          height: 10.0, // 동그라미 크기 조절
                          margin: EdgeInsets.only(
                              top: 6.0, right: 8.0), // 동그라미 위치 조절
                          decoration: BoxDecoration(
                            color: text.startsWith("A")
                                ? Colors.red
                                : text.startsWith("B")
                                    ? Colors.blue
                                    : Colors.green, // A, B, C에 따라 다른 색상 적용
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            text,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Text(playbackSpeed == PlaybackSpeed.normal
                  ? '1x'
                  : playbackSpeed == PlaybackSpeed.doubleSpeed
                      ? '2x'
                      : '3x'),
              onPressed: () {
                setState(() {
                  if (playbackSpeed == PlaybackSpeed.normal) {
                    playbackSpeed = PlaybackSpeed.doubleSpeed;
                  } else if (playbackSpeed == PlaybackSpeed.doubleSpeed) {
                    playbackSpeed = PlaybackSpeed.tripleSpeed;
                  } else {
                    playbackSpeed = PlaybackSpeed.normal;
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.fast_rewind),
              onPressed: () {
                // 10초 이전으로 감기 버튼 눌렀을 때 동작
              },
            ),
            isPlaying
                ? IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: () {
                      setState(() {
                        isPlaying = false;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () {
                      setState(() {
                        isPlaying = true;
                      });
                    },
                  ),
            IconButton(
              icon: Icon(Icons.fast_forward),
              onPressed: () {
                // 10초 이후로 감기 버튼 눌렀을 때 동작
              },
            ),
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                // 말풍선 아이콘 버튼 눌렀을 때 동작
              },
            ),
          ],
        ),
      ),
    );
  }
}
