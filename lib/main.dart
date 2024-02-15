import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdsc/auth/login_page.dart';
import 'package:gdsc/home/home_screen_page.dart';
import 'package:gdsc/provider/bottom_bar_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // add providers here
        ChangeNotifierProvider(create: (context) => (BottomBarProvider())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Archivit',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: () async {
            // check if user is already logged in
            // if logged in, return user info jwt token
            // if not logged in, return ""

            return "";
          }(),
          builder: (context, snapshot) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              child: _splashLoadingWidget(snapshot),
            );
          },
        ),
      ),
    );
  }
}

Widget _splashLoadingWidget(AsyncSnapshot snapshot) {
  if (snapshot.hasError) {
    return Text("Error1: ${snapshot.error}");
  } else if (snapshot.hasData) {
    var userInfo = snapshot.data;
    if (userInfo != "") {
      // already logged in (token exists)
      return HomeScreen();
    } else {
      // not logged in (token does not exist)
      return LoginPage();
    }
  } else {
    // loading
    return LoginPage();
  }
}
