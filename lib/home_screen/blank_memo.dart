import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlankMemoController extends GetxController {
  // 추가적인 상태나 로직이 있다면 여기에 추가 가능
}

class BlankMemoPage extends StatelessWidget {
  final BlankMemoController controller = Get.put(BlankMemoController());
  final double leftPadding = 16.0; // 사용자가 조절 가능한 왼쪽 패딩 값

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0), // 화살표와 날짜 시간을 살짝 아래로 내리기 위한 여백 추가
            // 화살표 아이콘 및 날짜와 시간 표시
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // 이전 화면으로 이동
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 30.0,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 16.0), // 여백 추가
                Padding(
                  padding: EdgeInsets.only(left: 60.0),
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
            // 자유롭게 텍스트를 입력할 수 있는 TextField
            Expanded(
              child: TextField(
                maxLines: null, // 여러 줄의 텍스트 입력 허용
                decoration: InputDecoration(
                  hintText: '여기에 메모를 작성하세요',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 현재 날짜를 가져오는 도우미 메서드
  String _getCurrentDate() {
    DateTime now = DateTime.now();
    return "${now.year}/${_addLeadingZero(now.month)}/${_addLeadingZero(now.day)}";
  }

  // 현재 시간을 가져오는 도우미 메서드
  String _getCurrentTime() {
    DateTime now = DateTime.now();
    return "${_addLeadingZero(now.hour)}:${_addLeadingZero(now.minute)}";
  }

  // 한 자리 숫자 앞에 0을 추가하는 도우미 메서드
  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }
}
