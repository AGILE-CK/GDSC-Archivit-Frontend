import 'package:flutter/material.dart';
import 'package:gdsc/Login/login_page.dart';
import 'package:gdsc/Login/signup_complete_screen.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _signUp() {
    // 회원가입 처리 로직을 추가하세요.
    String name = _nameController.text;
    String phoneNumber = _phoneNumberController.text;
    String id = _idController.text;
    String password = _passwordController.text;

    // 예시: 간단한 회원가입 로직
    print('이름: $name');
    print('전화번호: $phoneNumber');
    print('ID: $id');
    print('비밀번호: $password');

    // 여기에 실제 회원가입 처리 로직을 추가하세요.
    // ...

    // 회원가입 완료 후 홈 화면으로 이동
    Get.off(() => SignUpCompleteScreen());
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
              controller: _nameController,
              decoration: InputDecoration(labelText: '이름'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: '전화번호'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
