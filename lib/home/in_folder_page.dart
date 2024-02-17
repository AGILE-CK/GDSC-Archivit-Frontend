import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdsc/colors.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../provider/folder_page_provider.dart';
import '../widget/floating_point.dart';

class InFolderPage extends StatefulWidget {
  @override
  _InFolderPageState createState() => _InFolderPageState();
}

class _InFolderPageState extends State<InFolderPage>
    with TickerProviderStateMixin {
  bool isTextSelected = true;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this, //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );

    super.initState();
  }

  Future<void> showEditDialog(FileSystemEntity file) async {
    return Get.defaultDialog(
      title: 'Edit file',
      content: Column(
        children: <Widget>[
          TextButton(
            child: Text('Rename'),
            onPressed: () {
              // Rename the file
              showRenameDialog(file);
            },
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              // Delete the file
              file.delete();
              Get.back(); // Close the dialog

              setState(() {});
              // Redraw the screen
            },
          ),
        ],
      ),
    );
  }

  Future<void> showRenameDialog(FileSystemEntity file) async {
    TextEditingController controller = TextEditingController();

    return Get.defaultDialog(
      title: 'Enter the new name',
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: file.path.split('/').last,
        ),
      ),
      textConfirm: 'Confirm',
      onConfirm: () {
        if (controller.text.trim().isEmpty) {
          Get.snackbar('Error', 'Name cannot be empty');
        } else {
          // Rename the file
          final newPath =
              '${file.path.split('/').sublist(0, file.path.split('/').length - 1).join('/')}/${controller.text.trim()}';

          file.renameSync(newPath);
          Get.back(); // Close the dialog

          Provider.of<FolderPageProvider>(context, listen: false)
              .listFilesAndTexts();
          setState(() {}); // Redraw the screen
          Get.back(); // Close the dialog
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FileSystemEntity folder = context.watch<FolderPageProvider>().selectedFile;
    List<FileSystemEntity> files = Directory(folder.path).listSync();

//.txt
    List<FileSystemEntity> texts = files
        .where((element) => element.path.split('.').last == 'txt')
        .toList();
    List<FileSystemEntity> voices = files
        .where((element) => element.path.split('.').last == 'm4a')
        .toList();

    return Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            onTap: (index) {
              setState(() {});
            },
            labelColor: Colors.black,
            indicator: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: firstBlue,
                  width: 3,
                ),
              ),
            ),
            controller: _tabController,
            tabs: [
              Tab(text: 'Text'),
              Tab(text: 'Voice'),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(folder.path.split('/').last,
              style: const TextStyle(color: Colors.blue)),
        ),
        floatingActionButton: floatingInInFolderPage(context),
        body: Consumer<FolderPageProvider>(builder: (context, data, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              ListView.builder(
                itemCount: texts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(texts[index].path.split('/').last),
                    onTap: () {
                      // if (isTextSelected) {
                      //   Get.toNamed('/text_memo_page', arguments: files[index]);
                      // } else {
                      //   Get.toNamed('/voice_memo_page', arguments: files[index]);
                      // }
                    },
                    onLongPress: () {
                      showEditDialog(texts[index]);
                    },
                  );
                },
              ),
              ListView.builder(
                itemCount: voices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(voices[index].path.split('/').last),
                    onTap: () {
                      // if (isTextSelected) {
                      //   Get.toNamed('/text_memo_page', arguments: files[index]);
                      // } else {
                      //   Get.toNamed('/voice_memo_page', arguments: files[index]);
                      // }
                    },
                    onLongPress: () {
                      showEditDialog(voices[index]);
                    },
                  );
                },
              ),
            ],
          );
        }));
  }
}
