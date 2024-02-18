import 'package:flutter/material.dart';
import 'package:gdsc/auth/signup_page.dart';
import 'package:gdsc/home/home_screen_page.dart';
import 'package:gdsc/service/backend_api.dart';
import 'package:gdsc/service/token_function.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  //Google login
  Future<void> _googleLogin() async {
    // 구글 로그인 처리 로직을 추가하세요.
    // ...

    var response = await googleLogin();

    if (response.statusCode == 200) {
      // 로그인 성공: 응답 본문을 출력하거나, 다음 페이지로 이동합니다.
      print('Response body: ${response.body}');
      // {token : "asdfasdf
      await setToken(response.body);
      Get.offAll(() => HomeScreen());
    } else {
      // 로그인 실패: 에러 메시지를 출력합니다.
      print('Failed to login: ${response.statusCode}');
    }
  }

  Future<void> _login() async {
    // 로그인 처리 로직을 추가하세요.
    String username = _usernameController.text;
    String password = _passwordController.text;

    var response = await login(username, password);

    if (response.statusCode == 200) {
      // 로그인 성공: 응답 본문을 출력하거나, 다음 페이지로 이동합니다.
      print('Response body: ${response.body}');
      // {token : "asdfasdf"}
      var token = response.body;

      await setToken(response.body);
      Get.offAll(() => HomeScreen());
    } else {
      // 로그인 실패: 에러 메시지를 출력합니다.
      print('Failed to login: ${response.statusCode}');
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _login, // todo

                  // onPressed: () => Get.offAll(() => HomeScreen()),
                  child: Text('Login'),
                ),
                // SizedBox(width: 16.0),
                // ElevatedButton(
                //   onPressed: _googleLogin, // todo
                //   child: Text('Google Login'),
                // ),
              ],
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => Get.to(SignUpPage()),
              child: Text(
                'Sign Up',
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
