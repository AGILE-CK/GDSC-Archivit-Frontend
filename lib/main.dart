import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:gdsc/auth/login_page.dart';
import 'package:gdsc/home/home_screen_page.dart';
import 'package:gdsc/home/voice_setting.dart';
import 'package:gdsc/provider/bottom_bar_provider.dart';
import 'package:gdsc/provider/folder_page_provider.dart';
import 'package:gdsc/provider/make_recording_page_provider.dart';
import 'package:gdsc/provider/make_text_file_page_provider.dart';
import 'package:gdsc/service/token_function.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:gdsc/home/voice_text.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 바인딩 초기화 보장

  await initservice();
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

const AndroidNotificationChannel notificationChannel =
    AndroidNotificationChannel(
  'coding is life foreground',
  'coding is life foreground service',
  description: 'This cheannle is descrip....',
);

Future<void> initservice() async {
  var service = FlutterBackgroundService();
  final FlutterLocalNotificationsPlugin flutterLocalPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS) {
    await flutterLocalPlugin.initialize(
        const InitializationSettings(iOS: DarwinInitializationSettings()));
  }

  await flutterLocalPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(notificationChannel);

  // service init and start
  await service.configure(
    iosConfiguration: IosConfiguration(
      onBackground: iosBackground,
      onForeground: onStart,
      autoStart: false,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: "Archivit",
      initialNotificationContent: "Initializing",
      initialNotificationTitle: "Recording",
      foregroundServiceNotificationId: 90,
    ),
  );
  // service.startService();
}

@pragma("vm:entry-point")
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalPlugin =
      FlutterLocalNotificationsPlugin();

  FlutterSoundRecorder recorder = FlutterSoundRecorder();

  var file_path = await getApplicationDocumentsDirectory();

  await recorder.openRecorder(); // await 추가
  await recorder.startRecorder(
    // await 추가
    toFile: file_path.path + "/test.mp4",
    codec: Codec.aacMP4,
  );

  service.on("setAsForeground").listen((event) {
    print("setAsForeground");
  });

  service.on("setAsBackground").listen((event) {
    print("setAsBackground");
  });

  service.on("stopService").listen((event) async {
    print("stopService");
    await recorder.stopRecorder();
    await recorder.closeRecorder();
    await service.stopSelf();
  });
  //display notification as service
  Timer.periodic(Duration(seconds: 2), (timer) {
    flutterLocalPlugin.show(
        90,
        "Cool Service",
        "Awsome ${DateTime.now()}",
        NotificationDetails(
            android: AndroidNotificationDetails(
          "coding is life",
          "coding is life service",
          ongoing: true,
        )));
  });

  print("Background service ${DateTime.now()}");
}

@pragma("vm:entry-point")
Future<bool> iosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
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
    return LoginPage();
  }
}
