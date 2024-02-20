import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gdsc/auth/signup_complete_screen.dart';
import 'package:gdsc/service/backend_api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _signUp() async {
    // 회원가입 처리 로직을 추가하세요.
    String email = _idController.text;
    String password = _passwordController.text;

    print('Email: $email');
    print('Password: $password');

    // 여기에 실제 회원가입 처리 로직을 추가하세요.
    // ...

    //auth/signup
    // @Param email body string true "email"
    // @Param password body string true "password"

    if (email == "" || password == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in the blanks')),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must be at least 8 characters')),
      );
      return;
    }

    var response = await signUp(email, password);

    if (response.statusCode == 200) {
      // 회원가입 성공: 응답 본문을 출력하거나, 다음 페이지로 이동합니다.
      print('Response body: ${response.body}');
      Get.off(() => SignUpCompleteScreen());
    } else {
      // 회원가입 실패: 에러 메시지를 출력합니다.
      print('Failed to sign up: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('SignUp'),
            ),
          ],
        ),
      ),
    );
  }
}
