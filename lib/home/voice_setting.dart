import 'package:flutter/material.dart';

class VoiceSettingScreen extends StatefulWidget {
  @override
  _VoiceSettingScreenState createState() => _VoiceSettingScreenState();
}

class _VoiceSettingScreenState extends State<VoiceSettingScreen> {
  List<String> recordedKeywords = [];
  List<Widget> keywordWidgets = [];
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16.0, top: 44.0, right: 16.0),
                  child: Text(
                    'Archivit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: TextField(
                                controller: _textEditingController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText:
                                      'Please enter the record trigger words',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  // No need to set state here
                                },
                                onSubmitted: (value) {
                                  _addKeyword(value);
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _addKeyword(_textEditingController.text);
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              color: Colors.transparent,
                              child: Text(
                                'Enter',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        height: 1.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: keywordWidgets,
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 80.0),
              child: Container(
                color: Colors.black,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Recommended ',
                            style: TextStyle(
                              color: Color(0xFF007AFF),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'keyword for initiating recording',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircle('report'),
                        _buildCircle('Stop'),
                        _buildCircle('Hey'),
                        _buildCircle('Start'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(String text) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black, // 배경색을 검정색으로 설정
        border: Border.all(color: Colors.white), // 테두리를 흰색 실선으로 설정
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _addKeyword(String value) {
    if (value.isNotEmpty) {
      setState(() {
        recordedKeywords.add(value);
        keywordWidgets = List.generate(recordedKeywords.length, (index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    recordedKeywords[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _removeKeyword(index);
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        });
      });
      _textEditingController.clear();
    }
  }

  void _removeKeyword(int index) {
    setState(() {
      recordedKeywords.removeAt(index);
      keywordWidgets.removeAt(index);
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: VoiceSettingScreen(),
  ));
}
