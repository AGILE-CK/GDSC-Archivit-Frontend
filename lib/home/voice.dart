import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoiceScreenController extends GetxController {
  // Your controller logic here
}

class VoiceScreen extends StatelessWidget {
  final VoiceScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(left: 16.0, top: 44.0),
              child: Text(
                'Archivit',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40.0,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(left: 30.0, top: 1.0),
              child: Text(
                'Voice Page',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          // Your VoiceScreen content...
        ],
      ),
    );
  }
}
