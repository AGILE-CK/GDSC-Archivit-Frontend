import 'package:flutter/material.dart';
import 'package:gdsc/Login/signup_page.dart';
import 'package:get/get.dart';

import 'login_page.dart'; // 로그인 페이지 파일 임포트

class SignUpCompleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 완료'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '회원가입이 완료되었습니다!',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // 새로운 SignUpPage를 띄워 이동
                Get.offAll(() => LoginPage());
              },
              child: Text('로그인 화면으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
