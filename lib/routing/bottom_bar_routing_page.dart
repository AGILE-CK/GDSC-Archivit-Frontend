import 'package:flutter/material.dart';
import 'package:gdsc/home/home_screen_page.dart';
import 'package:gdsc/home/voice_setting.dart';
import 'package:gdsc/provider/bottom_bar_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BottomBarRoutingPage extends StatefulWidget {
  @override
  _BottomBarRoutingPageState createState() => _BottomBarRoutingPageState();
}

class _BottomBarRoutingPageState extends State<BottomBarRoutingPage> {
  List<Widget> navBarPages = [
    HomeScreen(),
    VoiceSettingScreen(),
    // HomeScreen(),
    // HomeScreen(),
  ];

  void _onItemTapped(int index) {
    Provider.of<BottomBarProvider>(context, listen: false).currentIndex = index;
    Get.offAll(() => navBarPages[index]);
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = Provider.of<BottomBarProvider>(context).currentIndex;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image(image: AssetImage('assets/icon/home.jpg')),
            activeIcon: Image(
                image: AssetImage('assets/icon/home.jpg')), // active icon color
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: Image(image: AssetImage('assets/icon/idea.jpg')),
          //   activeIcon: Image(
          //       image: AssetImage('assets/icon/idea.jpg')), // active icon color
          //   label: 'Idea',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.record_voice_over),
            activeIcon: Icon(Icons.record_voice_over), // active icon color
            label: 'Background Record',
          ),
          // BottomNavigationBarItem(
          //   icon: Image(image: AssetImage('assets/icon/profile.jpg')),
          //   activeIcon: Image(
          //       image:
          //           AssetImage('assets/icon/profile.jpg')), // active icon color
          //   label: 'Profile',
          // ),
        ],
        currentIndex: selectedIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black, // 추가

        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
