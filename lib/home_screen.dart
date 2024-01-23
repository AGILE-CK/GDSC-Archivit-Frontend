import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
                  fontFamily: 'HGGGothicssi_Pro',
                  fontSize: 40.0,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                height: 36.0, // 검색 상자의 높이
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    filled: true,
                    fillColor: Colors.grey[500], // 회색 배경색
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none, // 테두리 선 없음
                      borderRadius: BorderRadius.circular(5.0), // 둥근 모서리
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
