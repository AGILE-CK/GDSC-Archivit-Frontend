import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gdsc/auth/login_page.dart';
import 'package:gdsc/home/home_screen_page.dart';
import 'package:gdsc/home/voice_setting.dart';
import 'package:gdsc/provider/bottom_bar_provider.dart';
import 'package:gdsc/provider/folder_page_provider.dart';
import 'package:gdsc/provider/make_recording_page_provider.dart';
import 'package:gdsc/provider/make_text_file_page_provider.dart';
import 'package:gdsc/service/token_function.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:gdsc/home/voice_text.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // add providers here
        ChangeNotifierProvider(create: (context) => (BottomBarProvider())),
        ChangeNotifierProvider(create: (context) => (FolderPageProvider())),
        ChangeNotifierProvider(
            create: (context) => (MakeRecordingPageProvider())),
        ChangeNotifierProvider(
            create: (context) => (MakeTextFilePageProvider())),
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
            var folderPageProvider = context.read<FolderPageProvider>();
            folderPageProvider.listFilesAndTexts();

            var token = await getToken();
            if (token != null) {
              return token;
            } else {
              return "";
            }
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
    print("Error: ${snapshot.error}");
    return Text("Error1: ${snapshot.error}");
  } else if (snapshot.hasData && snapshot.data != "" && snapshot.data != null) {
    return HomeScreen();
  } else {
    // loading
    return VoiceTextScreen();
  }
}
