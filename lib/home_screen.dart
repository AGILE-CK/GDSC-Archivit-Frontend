import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isTextSelected = true; // 사용자가 Text를 눌렀는지 여부

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
              color: Color(0xFFF2F8F8),
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isTextSelected = true;
                      });
                    },
                    child: Container(
                      width: 120.0,
                      height: 20.0,
                      decoration: isTextSelected
                          ? BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                bottomLeft: Radius.circular(25.0),
                              ),
                            )
                          : BoxDecoration(
                              color: Color(0xFF767680),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                bottomLeft: Radius.circular(25.0),
                              ),
                            ),
                      child: Center(
                        child: Text(
                          'Text',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: isTextSelected ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isTextSelected = false;
                      });
                    },
                    child: Container(
                      width: 120.0,
                      height: 20.0,
                      decoration: !isTextSelected
                          ? BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25.0),
                                bottomRight: Radius.circular(25.0),
                              ),
                            )
                          : BoxDecoration(
                              color: Color(0xFF767680),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25.0),
                                bottomRight: Radius.circular(25.0),
                              ),
                            ),
                      child: Center(
                        child: Text(
                          'Voice',
                          style: TextStyle(
                            fontSize: 16.0,
                            color:
                                !isTextSelected ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: Color(0xFFF2F8F8),
              margin: EdgeInsets.only(bottom: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Implement the action when the '+' is pressed
                      },
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: isTextSelected ? Colors.red : Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
