import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlankMemoController extends GetxController {
  // 추가적인 상태나 로직이 있다면 여기에 추가 가능
}

class BlankMemoPage extends StatefulWidget {
  @override
  _BlankMemoPageState createState() => _BlankMemoPageState();
}

class _BlankMemoPageState extends State<BlankMemoPage> {
  final BlankMemoController controller = Get.put(BlankMemoController());
  final double leftPadding = 16.0; // 사용자가 조절 가능한 왼쪽 패딩 값
  final TextEditingController _textEditingController = TextEditingController();

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
}
