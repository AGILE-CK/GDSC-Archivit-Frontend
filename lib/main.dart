import 'package:flutter/material.dart';
import 'package:gdsc/Login/login_page.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Pretendard',
    ),
    home: LoginPage(),
  ));
}
