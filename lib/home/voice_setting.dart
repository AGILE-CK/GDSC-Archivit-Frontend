import 'package:flutter/material.dart';

class VoiceSettingScreen extends StatefulWidget {
  @override
  _VoiceSettingScreenState createState() => _VoiceSettingScreenState();
}

class _VoiceSettingScreenState extends State<VoiceSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          CustomScrollView(slivers: <Widget>[
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
                        ])))
          ])
        ]));
  }
}
