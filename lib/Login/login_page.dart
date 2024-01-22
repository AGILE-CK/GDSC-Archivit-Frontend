import 'package:flutter/material.dart';
import 'package:gdsc/Login/signup_page.dart';
import 'package:gdsc/home_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _login() {
    // 로그인 처리 로직을 추가하세요.
    String username = _usernameController.text;
    String password = _passwordController.text;

    // 예시: 간단한 로그인 로직
    if (username == '사용자명' && password == '비밀번호') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('로그인 성공!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.offAll(() => HomeScreen());
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('로그인 실패'),
            content: Text('사용자명 또는 비밀번호를 확인하세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              // onPressed: _login, // todo
              onPressed: () => Get.offAll(() => HomeScreen()),
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => Get.to(SignUpPage()),
              child: Text(
                '회원가입',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
