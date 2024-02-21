import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:gdsc/home/home_screen_page.dart';
import 'package:gdsc/provider/folder_page_provider.dart';
import 'package:gdsc/service/get_default_directory.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class VoiceSettingScreen extends StatefulWidget {
  @override
  _VoiceSettingScreenState createState() => _VoiceSettingScreenState();
}

class _VoiceSettingScreenState extends State<VoiceSettingScreen> {
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  late Directory file_path;

  //init
  @override
  void initState() {
    super.initState();
    initializeDirectory();
  }

  void initializeDirectory() {
    createUserDataDirectory().then((dir) {
      file_path = dir;
    });
  }

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => HomeScreen());
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20.0),
                        margin: const EdgeInsets.only(right: 95.0, top: 25.0),
                        child: const Text(
                          'Archivit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50.0,
                            fontWeight: FontWeight.w900,
                            height: 1.2,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                            text: 'Start ',
                            style: TextStyle(
                              color: Color(0xFF007AFF),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                'Background Recording with trigger by violent sound',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            print("Start service");

                            FlutterBackgroundService().startService();
                          },
                          child: _buildCircle('START'),
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            FlutterBackgroundService().invoke(
                              "stopService",
                            );
                            Provider.of<FolderPageProvider>(context,
                                    listen: false)
                                .listFilesAndTexts();
                          },
                          child: _buildCircle('STOP'),
                        ),
                      ],
                    )
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
        color: Colors.black,
        border: Border.all(color: Colors.white),
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
}
