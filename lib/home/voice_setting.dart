import 'package:flutter/material.dart';

class VoiceSettingScreen extends StatefulWidget {
  @override
  _VoiceSettingScreenState createState() => _VoiceSettingScreenState();
}

class _VoiceSettingScreenState extends State<VoiceSettingScreen> {
  String recordingKeyword = '';

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
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.white), // 흰색 실선 테두리 추가
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: '녹음 시작 단어를 입력해주세요',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                recordingKeyword = value;
                              });
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // 등록 버튼을 눌렀을 때의 동작 추가
                          // 여기서는 입력한 키워드를 출력하도록 함
                          print('등록된 키워드: $recordingKeyword');
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          color: Colors.transparent,
                          child: Text(
                            '등록',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
