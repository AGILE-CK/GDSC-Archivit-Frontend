import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:gdsc/service/ai_api.dart';
import 'package:gdsc/service/preference_function.dart';

class Conversation {
  final String speaker;
  final String message;

  Conversation(this.speaker, this.message);
}

class VoiceTextScreen extends StatefulWidget {
  final String filePath;

  VoiceTextScreen({required this.filePath});
  @override
  _VoiceTextScreenState createState() => _VoiceTextScreenState();
}

class _VoiceTextScreenState extends State<VoiceTextScreen> {
  bool isPlaying = false;
  String filePath = "";
  Map<String, dynamic> transcript = {};
  String summary = "";

  // 대화를 나타내는 Conversation 객체의 리스트
  List<Conversation> conversation = [];
  FlutterSoundPlayer _player = FlutterSoundPlayer();
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.yellow,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.lime,
    Colors.amber,
    Colors.deepOrange,
  ];

  bool isTranscriptExist = false;
  bool isSummaryExist = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    filePath = widget.filePath;
    Future.delayed(Duration(milliseconds: 1), () async {
      var jsonMap = await getTranscriptJSON(filePath);

      if (jsonMap != null) {
        setState(() {
          isTranscriptExist = true;
          transcript = json.decode(jsonMap);
          _loadTranscript();
        });

        var summaryJsonMap = await getSummaryJSON(filePath);
        if (summaryJsonMap != null) {
          setState(() {
            isSummaryExist = true;
            summary = summaryJsonMap;
          });
        }
      }
    });
    _player.openAudioSession();
  }

  @override
  void dispose() {
    _player.closeAudioSession();
    conversation.clear();
    transcript.clear();
    isTranscriptExist = false;
    isSummaryExist = false;
    super.dispose();
  }

  void _loadTranscript() {
    for (var item in transcript['transcriptions']) {
      int speakerNum =
          int.parse(item[0].substring(8)); // Get the number after 'SPEAKER_'
      String speaker = String.fromCharCode(
          65 + speakerNum); // Convert the number to an alphabet letter
      String message = item[1];

      conversation.add(Conversation(speaker, message));
    }
  }

  Future<void> _play() async {
    await _player.startPlayer(fromURI: filePath, codec: Codec.aacMP4);
  }

  Future<void> _pause() async {
    await _player.pausePlayer();
  }

  Future<void> _forward() async {
    await _player.seekToPlayer(Duration(seconds: 5));
  }

  Future<void> _rewind() async {
    await _player.seekToPlayer(Duration(seconds: -5));
  }

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
                  SizedBox(height: 5.0),
                  Text(
                    File(filePath)
                        .statSync()
                        .modified
                        .toLocal()
                        .toString()
                        .split('.')[0],
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.0),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // 링크와 공유 아이콘을 오른쪽으로 정렬
                    children: [
                      Text(
                        'Voice to Text',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
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
            SizedBox(height: 10.0),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              )
            else if (!isTranscriptExist && !isSummaryExist)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    transcribeFile(File(filePath)).then((result) {
                      transcript = result;
                      _loadTranscript();
                      setState(() {
                        saveTrascriptJSON(result, filePath);
                        isTranscriptExist = true;
                        isLoading = false;
                      });
                    });
                  },
                  child: Text('Try Transcript'),
                ),
              )
            else if (isTranscriptExist && !isSummaryExist)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    summarizeJson(transcript).then((result) {
                      summary = result;

                      saveSummaryJSON(summary, filePath);
                      setState(() {
                        isSummaryExist = true;
                        isLoading = false;
                      });
                    });
                  },
                  child: Text('Try Summary'),
                ),
              )
            else
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
                      '🤖',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      summary,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 10.0),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: conversation.map((conv) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            margin: EdgeInsets.only(top: 6.0, right: 8.0),
                            decoration: BoxDecoration(
                              color: colors[conv.speaker.codeUnitAt(0) - 65],
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  conv.speaker,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  conv.message,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.fast_rewind),
                onPressed: () {
                  // 10초 이전으로 감기 버튼 눌렀을 때 동작
                  _rewind();
                },
              ),
              isPlaying
                  ? IconButton(
                      icon: Icon(Icons.pause),
                      onPressed: () {
                        _pause();
                        setState(() {
                          isPlaying = false;
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        _play();
                        setState(() {
                          isPlaying = true;
                        });
                      },
                    ),
              IconButton(
                icon: Icon(Icons.fast_forward),
                onPressed: () {
                  // 10초 이후로 넘기기 버튼 눌렀을 때 동작
                  _forward();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
