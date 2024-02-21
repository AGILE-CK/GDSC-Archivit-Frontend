import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gdsc/colors.dart';
import 'package:gdsc/home/memo/blank_memo_page.dart';
import 'package:gdsc/home/memo/dating_memo_page.dart';
import 'package:gdsc/home/memo/domestic_memo_page.dart';
import 'package:gdsc/home/memo/school_memo_page.dart';
import 'package:gdsc/home/recording.dart';
import 'package:gdsc/provider/folder_page_provider.dart';
import 'package:gdsc/provider/in_folder_page_provider.dart';
import 'package:gdsc/provider/make_file_page_provider.dart';
import 'package:gdsc/service/get_default_directory.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

SpeedDialChild buildSpeedDialChild(
    String text, IconData icon, VoidCallback onTap) {
  return SpeedDialChild(
    labelWidget: Container(
      width: 170,
      height: 35,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: floatingBackgroundColor,
        border: Border.all(
          color: Colors.grey,
          width: 0.1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 5),
          Icon(icon),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    ),
    onTap: onTap,
  );
}

SpeedDial floatingInHomePage(context) {
  return SpeedDial(
    /// 플로팅 버튼의 기본 상태를 설정합니다.
    icon: Icons.add,
    // animatedIconTheme: const IconThemeData(size: 22.0),
    backgroundColor: firstBlue,
    foregroundColor: Colors.white,
    shape: const CircleBorder(),

    children: [
      buildSpeedDialChild('Voice Memo', FluentIcons.person_voice_16_regular,
          () {
        Provider.of<MakeFilePageProvider>(context, listen: false).setPath('');
        makeRecordDialog(context);
      }),
      buildSpeedDialChild('Text Memo', FluentIcons.document_16_regular, () {
        Provider.of<MakeFilePageProvider>(context, listen: false).setPath('');
        showTemplateDialog(context);
      }),
      buildSpeedDialChild('Folder', FluentIcons.folder_16_regular, () {
        Provider.of<MakeFilePageProvider>(context, listen: false).setPath('');
        makeFolderDialog(context);
      }),
    ],
  );
}

Future<void> makeRecordDialog(context) async {
  TextEditingController controller = TextEditingController();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter the name of the file'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'File name',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              if (controller.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name cannot be empty')),
                );
              } else {
                Provider.of<MakeFilePageProvider>(context, listen: false)
                    .setFileName(controller.text.trim());
                Navigator.of(context).pop(); // 대화 상자를 닫습니다.
                Get.to(
                  () => RecordingScreen(),
                );
              }
            },
          ),
        ],
      );
    },
  );
}

Future<void> makeFolderDialog(context) async {
  TextEditingController controller = TextEditingController();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter the name of the folder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Folder name',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Confirm'),
            onPressed: () async {
              if (controller.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name cannot be empty')),
                );
              } else {
                final directory = await createUserDataDirectory();
                final folderPath =
                    '${directory.path}/${controller.text.trim()}';

                // Create a folder in the app document directory
                final folder = Directory(folderPath);
                if (!await folder.exists()) {
                  await folder.create();
                }

                Navigator.of(context).pop(); // 대화 상자를 닫습니다.
                Provider.of<FolderPageProvider>(context, listen: false)
                    .listFilesAndTexts();
              }
            },
          ),
        ],
      );
    },
  );
}

Future<void> showTemplateDialog(context) async {
  return Get.defaultDialog(
    title: 'Choose a template',
    content: Column(
      children: <Widget>[
        TextButton(
            child: const Text('Blank Memo'),
            onPressed: () {
              showNameDialog('Blank Memo', BlankMemoPage(), context);
            }),
        TextButton(
            child: const Text('School Template'),
            onPressed: () {
              showNameDialog('School Template', SchoolMemoPage(), context);
            }),
        TextButton(
            child: const Text('Domestic Template'),
            onPressed: () {
              showNameDialog('Domestic Template', DomesticMemoPage(), context);
            }),
        TextButton(
            child: const Text('Dating Template'),
            onPressed: () {
              showNameDialog('Dating Template', DatingMemoPage(), context);
            }),
      ],
    ),
  );
}

Future<void> showNameDialog(String template, Widget page, context) async {
  TextEditingController controller = TextEditingController();

  return Get.defaultDialog(
    title: 'Enter the name of the file',
    content: TextField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'File name',
      ),
    ),
    textConfirm: 'Confirm',
    onConfirm: () {
      if (controller.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name cannot be empty')),
        );
      } else {
        Provider.of<MakeFilePageProvider>(context, listen: false)
            .setFileName(controller.text.trim());
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Get.to(() => page); // Go to the template page
      }
    },
  );
}

SpeedDial floatingInInFolderPage(BuildContext context) {
  return SpeedDial(
    icon: Icons.add,
    backgroundColor: firstBlue,
    foregroundColor: Colors.white,
    shape: const CircleBorder(),
    children: [
      buildSpeedDialChild('Voice Memo', FluentIcons.person_voice_16_regular,
          () {
        String path = Provider.of<FolderPageProvider>(context, listen: false)
            .selectedFile
            .path
            .split('/')
            .last;
        Provider.of<MakeFilePageProvider>(context, listen: false).setPath(path);
        makeRecordDialog(context);
      }),
      buildSpeedDialChild('Text Memo', FluentIcons.document_16_regular, () {
        String path = Provider.of<FolderPageProvider>(context, listen: false)
            .selectedFile
            .path
            .split('/')
            .last;
        Provider.of<MakeFilePageProvider>(context, listen: false).setPath(path);
        showTemplateDialog(context);
      }),
    ],
  );
}
