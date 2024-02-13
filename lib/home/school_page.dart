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

  // 각 섹션에 대한 별도의 TextEditingController 추가
  final TextEditingController _incidentStatementController =
      TextEditingController();
  final TextEditingController _witnessesController = TextEditingController();
  final TextEditingController _feelingsController = TextEditingController();
  final TextEditingController _desiredActionController =
      TextEditingController();
  // evidence 섹션에서 텍스트를 입력하는 부분 삭제
  // final TextEditingController _evidenceController = TextEditingController();

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
        body: SingleChildScrollView(
          child: Padding(
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
                      isIncidentStatementExpanded =
                          !isIncidentStatementExpanded;
                    });
                  },
                  textEditingController: _incidentStatementController,
                  additionalText: '',
                ),
                _buildExpandableSectionWithWarning(
                  title: "Presence of Any Witnesses",
                  isExpanded: isWitnessesExpanded,
                  onTap: () {
                    setState(() {
                      isWitnessesExpanded = !isWitnessesExpanded;
                    });
                  },
                  textEditingController: _witnessesController,
                ),
                _buildExpandableSectionWithAdditionalText(
                  title: "Feelings",
                  isExpanded: isFeelingsExpanded,
                  onTap: () {
                    setState(() {
                      isFeelingsExpanded = !isFeelingsExpanded;
                    });
                  },
                  textEditingController: _feelingsController,
                  hintText: "Enter your feeling here",
                  additionalText: '', // 수정: 힌트 텍스트 추가
                ),
                _buildExpandableSectionWithAdditionalText(
                  title: "Desired Action",
                  isExpanded: isDesiredActionExpanded,
                  onTap: () {
                    setState(() {
                      isDesiredActionExpanded = !isDesiredActionExpanded;
                    });
                  },
                  textEditingController: _desiredActionController,
                  hintText: "Enter your desired action here",
                  additionalText: '', // 수정: 힌트 텍스트 추가
                ),
                _buildExpandableSection(
                  title: "Evidence",
                  isExpanded: isEvidenceExpanded,
                  onTap: () {
                    setState(() {
                      isEvidenceExpanded = !isEvidenceExpanded;
                    });
                  },
                  textEditingController: null,
                  additionalText:
                      "⚠️ If there are photos, videos, or recordings, please attach them (Screenshots are also acceptable)\n"
                      "⚠️ If you have been injured due to the violence, please go to the hospital and obtain a medical diagnosis, and attach the medical report here\n"
                      "⚠️ If you have CCTV footage, please upload it here.\n"
                      "⚠️ If you’ve had counseling sessions after the incident, please upload the counseling records here.",
                  hintText: '',
                ),
                SizedBox(height: 16.0),
              ],
            ),
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
    TextEditingController? textEditingController,
    String? hintText,
    required String additionalText,
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
                SizedBox(height: 8.0),
                if (textEditingController != null)
                  TextField(
                    controller: textEditingController,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                    ),
                  ),
                if (textEditingController != null) SizedBox(height: 8.0),
                if (additionalText.isNotEmpty) // 추가: 조건을 추가하여 표시 여부 결정
                  Text(
                    additionalText,
                    style: TextStyle(fontSize: 14.0),
                  ),
                SizedBox(height: 8.0),
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
    TextEditingController? textEditingController,
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

  Widget _buildExpandableSectionWithAdditionalText({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    TextEditingController? textEditingController,
    String? additionalText,
    required String hintText,
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
                if (textEditingController != null)
                  TextField(
                    controller: textEditingController,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                if (additionalText != null) SizedBox(height: 8.0),
                if (additionalText != null)
                  Text(
                    additionalText,
                    style: TextStyle(fontSize: 14.0),
                  ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
