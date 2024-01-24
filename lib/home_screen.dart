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
                'Archivit111',
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
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Color(0xFF3C3C43),
                      size: 20.0,
                    ),
                    SizedBox(width: 4.0),
                    Expanded(
                      child: TextField(
                        style: TextStyle(fontSize: 16.0),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: Implement voice input functionality
                      },
                      child: Icon(
                        Icons.mic,
                        color: Color(0xFF3C3C43),
                        size: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(left: 30.0, top: 1.0),
              child: Text(
                'Templates',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              height: 104.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRoundedRectangle("Blank memo"),
                  _buildRoundedRectangle("School"),
                  _buildRoundedRectangle("Dating"),
                  _buildRoundedRectangle("Domestic"),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: Color(0xFFF2F8F8),
              margin: EdgeInsets.only(bottom: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 16.0, bottom: 20.0),
                    child: Text(
                      '아래쪽 갈래 페이지',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // 아래쪽 갈래 페이지에 대한 추가 SliverToBoxAdapter 또는 다른 Sliver 위젯을 추가하세요.
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedRectangle(String title) {
    return Container(
      width: 80.0,
      height: 104.0,
      child: Column(
        children: [
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
