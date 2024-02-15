import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // 추가된 라이브러리
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

  bool isIncidentStatementExpanded = false;
  bool isWitnessesExpanded = false;
  bool isFeelingsExpanded = false;
  bool isDesiredActionExpanded = false;
  bool isEvidenceExpanded = false;

  int selectedDate = DateTime.now().day; // 추가된 변수: 선택한 날짜
  String selectedMonthText =
      _getMonthText(DateTime.now().month); // 추가된 변수: 선택한 월 (텍스트 형식)
  int selectedYear = DateTime.now().year; // 추가된 변수: 선택한 연도

  bool isAMSelected = false; // 추가된 변수: AM 선택 여부
  bool isPMSelected = false; // 추가된 변수: PM 선택 여부

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
                  additionalText:
                      "⚠️ If the violence has persisted for an extended period, please provide more detailed information on the \"WHAT/HOW\" section regarding the specific start date and frequency",
                  belowText: "Date of incident", // 추가된 부분: 하단 텍스트
                ),
                if (isIncidentStatementExpanded)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showMonthPicker(context); // 추가된 부분: 월 선택기 보이기
                          },
                          child: Container(
                            height: 30.0,
                            margin: EdgeInsets.only(left: 4.0),
                            decoration: BoxDecoration(
                              color: Color(0xFF007AFF),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  selectedMonthText,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 20.0,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showDatePicker(context); // 추가된 부분: 날짜 선택기 보이기
                          },
                          child: Container(
                            height: 30.0,
                            margin: EdgeInsets.only(left: 4.0),
                            decoration: BoxDecoration(
                              color: Color(0xFF007AFF),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  selectedDate.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 20.0,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4.0),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showYearPicker(context); // 추가된 부분: 연도 선택기 보이기
                          },
                          child: Container(
                            height: 30.0,
                            margin: EdgeInsets.only(left: 4.0),
                            decoration: BoxDecoration(
                              color: Color(0xFF007AFF),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  selectedYear.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 20.0,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                if (isIncidentStatementExpanded) // 추가된 부분: 아래 텍스트 렌더링
                  Padding(
                    padding: EdgeInsets.only(left: 28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "When",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color(
                                    0xFF007AFF), // Incident Statement와 같은 색상
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              "Time of Incident", // 하단 텍스트 표시
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black, // 검정색
                              ),
                            ),
                            SizedBox(height: 8.0),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          "⚠️ If you don't know the exact time, please specify the time using situations (e.g. after the class finished)",
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // AM 상자
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isAMSelected = true;
                          isPMSelected = false;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 30,
                        margin: EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.0),
                          color: isAMSelected
                              ? Color(0xFF007AFF)
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            'AM',
                            style: TextStyle(
                              fontSize: 12,
                              color: isAMSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // PM 상자
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isPMSelected = true;
                          isAMSelected = false;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 30,
                        margin: EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.0),
                          color: isPMSelected
                              ? Color(0xFF007AFF)
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            'PM',
                            style: TextStyle(
                              fontSize: 12,
                              color: isPMSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 첫 번째 시간 상자 - Hour
                    GestureDetector(
                      onTap: () {
                        _showHourPicker(context); // 시간 선택 위젯 표시
                      },
                      child: _buildHourMinuteBox('Hour'),
                    ),
                    SizedBox(width: 8.0),
                    Text(':', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8.0),
                    // 두 번째 시간 상자 - Minute
                    GestureDetector(
                      onTap: () {
                        _showMinutePicker(context); // 분 선택 위젯 표시
                      },
                      child: _buildHourMinuteBox('Minute'),
                    ),
                    SizedBox(width: 8.0),
                    // 시간 구분자
                    Text('-', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8.0),
                    // 세 번째 시간 상자 - Hour
                    GestureDetector(
                      onTap: () {
                        _showHourPicker(context); // 시간 선택 위젯 표시
                      },
                      child: _buildHourMinuteBox('Hour'),
                    ),
                    SizedBox(width: 8.0),
                    Text(':', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8.0),
                    // 네 번째 시간 상자 - Minute
                    GestureDetector(
                      onTap: () {
                        _showMinutePicker(context); // 분 선택 위젯 표시
                      },
                      child: _buildHourMinuteBox('Minute'),
                    ),
                  ],
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
                  belowText: "Time of evidence", // 추가된 부분: 하단 텍스트
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
    required String belowText, // 추가된 매개변수: 하단 텍스트
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Icon(
                isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
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
                Row(
                  children: [
                    Text(
                      "When",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF007AFF), // Incident Statement와 같은 색상
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      belowText, // 수정된 부분: 하단 텍스트 표시
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black, // 검정색
                      ),
                    ),
                    SizedBox(height: 8.0),
                  ],
                ),
                SizedBox(height: 8.0),
                Text(
                  additionalText,
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 8.0),
                if (textEditingController != null)
                  TextField(
                    controller: textEditingController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(fontSize: 14.0),
                      border: OutlineInputBorder(),
                    ),
                  ),
              ],
            ),
          ),
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
                isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
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
                SizedBox(height: 8.0),
                Text(
                  "⚠️ Please ensure to obtain the contact details of the witnesses (name, contact number, e-mail)",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 8.0),
                if (textEditingController != null)
                  TextField(
                    controller: textEditingController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Enter the witnesses here",
                      hintStyle: TextStyle(fontSize: 14.0),
                      border: OutlineInputBorder(),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildExpandableSectionWithAdditionalText({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    TextEditingController? textEditingController,
    required String hintText,
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
                isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
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
                SizedBox(height: 8.0),
                Text(
                  additionalText,
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 8.0),
                if (textEditingController != null)
                  TextField(
                    controller: textEditingController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(fontSize: 14.0),
                      border: OutlineInputBorder(),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildHourMinuteBox(String text) {
    return Container(
      width: 40,
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  // 추가된 함수: 월 선택기 표시
  Future<void> _showMonthPicker(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
  }

  // 추가된 함수: 날짜 선택기 표시
  Future<void> _showDatePicker(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
  }

  // 추가된 함수: 연도 선택기 표시
  Future<void> _showYearPicker(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
  }

  // 추가된 함수: 시간 선택 위젯 표시
  Future<void> _showHourPicker(BuildContext context) async {
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  // 추가된 함수: 분 선택 위젯 표시
  Future<void> _showMinutePicker(BuildContext context) async {
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  // 추가된 함수: 월 텍스트 변환
  static String _getMonthText(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
