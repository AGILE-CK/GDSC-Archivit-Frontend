import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchoolPageController extends GetxController {
  // 추가적인 상태나 로직이 있다면 여기에 추가 가능
}

class SchoolPage extends StatefulWidget {
  @override
  _SchoolPageState createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  final SchoolPageController controller = Get.put(SchoolPageController());
  final double leftPadding = 16.0; // 사용자가 조절 가능한 왼쪽 패딩 값
  final TextEditingController _textEditingController = TextEditingController();

  bool isIncidentStatementExpanded = false;
  bool isWitnessesExpanded = false;
  bool isFeelingsExpanded = false;
  bool isDesiredActionExpanded = false;
  bool isEvidenceExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 터치 시 텍스트 필드에 포커스를 줍니다.
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 30.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_getCurrentDate()} ${_getCurrentTime()}",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              _buildExpandableSection(
                title: "Incident Statement",
                isExpanded: isIncidentStatementExpanded,
                onTap: () {
                  setState(() {
                    isIncidentStatementExpanded = !isIncidentStatementExpanded;
                  });
                },
              ),
              _buildExpandableSectionWithWarning(
                title: "Presence of Any Witnesses",
                isExpanded: isWitnessesExpanded,
                onTap: () {
                  setState(() {
                    isWitnessesExpanded = !isWitnessesExpanded;
                  });
                },
              ),
              _buildExpandableSection(
                title: "Feelings",
                isExpanded: isFeelingsExpanded,
                onTap: () {
                  setState(() {
                    isFeelingsExpanded = !isFeelingsExpanded;
                  });
                },
              ),
              _buildExpandableSection(
                title: "Desired Action",
                isExpanded: isDesiredActionExpanded,
                onTap: () {
                  setState(() {
                    isDesiredActionExpanded = !isDesiredActionExpanded;
                  });
                },
              ),
              _buildExpandableSection(
                title: "Evidence",
                isExpanded: isEvidenceExpanded,
                onTap: () {
                  setState(() {
                    isEvidenceExpanded = !isEvidenceExpanded;
                  });
                },
              ),
              Expanded(
                child: Container(
                  child: TextField(
                    controller: _textEditingController,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCurrentDate() {
    DateTime now = DateTime.now();
    return "${now.year}/${_addLeadingZero(now.month)}/${_addLeadingZero(now.day)}";
  }

  String _getCurrentTime() {
    DateTime now = DateTime.now();
    return "${_addLeadingZero(now.hour)}:${_addLeadingZero(now.minute)}";
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Icon(
                Icons.arrow_downward,
                size: 20.0,
                color: Color(0xFF007AFF),
              ),
              SizedBox(width: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFF007AFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (isExpanded)
          Padding(
            padding: EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Additional details or functionality related to $title",
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        SizedBox(height: 8.0),
      ],
    );
  }

  Widget _buildExpandableSectionWithWarning({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Icon(
                Icons.arrow_downward,
                size: 20.0,
                color: Color(0xFF007AFF),
              ),
              SizedBox(width: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFF007AFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (isExpanded)
          Padding(
            padding: EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "⚠️ If there are witnesses, please record their statements",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  "in either audio or written form (Guidelines for writing witness statements)",
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
