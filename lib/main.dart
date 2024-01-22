import 'package:flutter/material.dart';
import 'package:gdsc/Login/login_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Pretendard',
    ),
    home: LoginPage(),
  ));
}
