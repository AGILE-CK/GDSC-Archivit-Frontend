import 'package:flutter/material.dart';
import 'package:gdsc/auth/signup_page.dart';
import 'package:get/get.dart';

import 'login_page.dart'; // 로그인 페이지 파일 임포트

class SignUpCompleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up Complete'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign Up Complete',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // 새로운 SignUpPage를 띄워 이동
                Get.offAll(() => LoginPage());
              },
              child: Text('Go to Login Page'),
            ),
          ],
        ),
      ),
    );
  }
}
