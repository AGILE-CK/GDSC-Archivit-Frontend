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
import 'package:gdsc/provider/bottom_bar_provider.dart';
import 'package:gdsc/provider/folder_page_provider.dart';

import 'package:gdsc/service/ai_api.dart';
import 'package:gdsc/provider/in_folder_page_provider.dart';
import 'package:gdsc/provider/make_file_page_provider.dart';
import 'package:gdsc/service/get_default_directory.dart';
import 'package:gdsc/service/preference_function.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 바인딩 초기화 보장
  // await initRecorder();

  await initservice();
  runApp(
    MultiProvider(
      providers: [
        // add providers here
        ChangeNotifierProvider(create: (context) => (BottomBarProvider())),
        ChangeNotifierProvider(create: (context) => (FolderPageProvider())),
        ChangeNotifierProvider(create: (context) => (InFolderPageProvider())),
        ChangeNotifierProvider(create: (context) => (MakeFilePageProvider())),
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

// FlutterSound 객체 생성
FlutterSoundRecorder _recorder = FlutterSoundRecorder();
FlutterSoundRecorder _recorder2 = FlutterSoundRecorder();

// 녹음 시작 함수
Future<String> _startRecording() async {
  Directory tempDir = await createUserDataDirectory();
  String path = '${tempDir.path}/flutter_sound-tmp.mp4';
  await _recorder.openAudioSession();
  _recorder.startRecorder(
    toFile: path,
    codec: Codec.aacMP4,
  );
  return path;
}

// Future<String> _startRecording2() async {
//   Directory tempDir = await createUserDataDirectory();
//   String path = '${tempDir.path}/flutter_sound-tmp2.mp4';
//   await _recorder2.openAudioSession();
//   _recorder2.startRecorder(
//     toFile: path,
//     codec: Codec.aacMP4,
//   );
//   return path;
// }

// 녹음 중지 및 파일 삭제 함수
Future<bool> _stopRecording(String path) async {
  await _recorder.stopRecorder();
  await _recorder.closeAudioSession();

  File file = File(path);

  var s = await violent(file);

  if (await file.exists()) {
    file.delete();
  }
  return s;
}

// Future<bool> _stopRecording2(String path) async {
//   await _recorder2.stopRecorder();
//   await _recorder2.closeAudioSession();

//   File file = File(path);

//   var s = await clam(file);

//   if (await file.exists()) {
//     file.delete();
//   }
//   return s;
// }

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

Future initRecorder() async {
  final status = await Permission.microphone.request();

  if (status != PermissionStatus.granted) {
    throw RecordingPermissionException("Microphone permission not granted");
  }
}

@pragma("vm:entry-point")
Future<void> onStart(ServiceInstance service) async {
  if (Platform.isAndroid) {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print("Microphone permission not granted");
      return;
    }
  }
  DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalPlugin =
      FlutterLocalNotificationsPlugin();

  FlutterSoundRecorder recorder = FlutterSoundRecorder();

  service.on("setAsForeground").listen((event) {
    print("setAsForeground");
  });

  service.on("setAsBackground").listen((event) {
    print("setAsBackground");
  });

  var cnt = 0;
  var isCheck = false;
  var isCheck2 = false;
  service.on("stopService").listen((event) async {
    print("stopService");
    Directory tempDir = await createUserDataDirectory();
    String path = '${tempDir.path}/flutter_sound-tmp.mp4';
    _stopRecording(path);
    isCheck = false;
    isCheck2 = false;
    await recorder.stopRecorder();
    await recorder.closeAudioSession();
    await service.stopSelf();
  });
  var saved_path = '';

  //display notification as service
  while (true) {
    var path = '';
    if (!isCheck) {
      path = await _startRecording();
    }
    // if (!isCheck2 && isCheck) {
    //   path = await _startRecording2();
    // }
    if (!isCheck) await Future.delayed(Duration(seconds: 10));

    if (!isCheck) {
      isCheck = await _stopRecording(path);
    }
    // else {
    //   isCheck2 = await _stopRecording2(path);
    // }

    if (isCheck && isCheck2) {
      // print("Calm or Default Situation"); we can not open recorder concurrently
      // so we just record during 20 seconds
      await recorder.stopRecorder();
      await recorder.closeAudioSession();

      // await service.stopSelf();
      // showStopDialog();

      isCheck = false;
      isCheck2 = false;
    } else if (isCheck) {
      print("Violent Situation Detected");
      var file_path = await createUserDataDirectory();
      var formatter = new DateFormat('MM-dd-hh:mm');
      String formattedDate = formatter.format(DateTime.now());

      await recorder.openAudioSession();
      saved_path = file_path.path + "/" + formattedDate + ".m4a";
      await recorder.startRecorder(
        toFile: saved_path,
        codec: Codec.aacMP4,
      );

      isCheck2 = true;
      Future.delayed(Duration(seconds: 120));
    } else {
      print("Waiting for the right condition to start recording...");
    }
  }
}

Future<void> showStartRecording() async {
  return Get.defaultDialog(
    title: 'Detect the violent sound. Start the recording now.',
  );
}

Future<void> showStopDialog() async {
  return Get.defaultDialog(
    title: 'Detect the calm sound. Stop the recording now. and save the file.',
  );
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
