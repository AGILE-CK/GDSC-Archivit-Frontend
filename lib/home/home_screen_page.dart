import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdsc/auth/login_page.dart';
import 'package:gdsc/home/in_folder_page.dart';
import 'package:gdsc/home/voice_text.dart';
import 'package:gdsc/provider/folder_page_provider.dart';
import 'package:gdsc/routing/bottom_bar_routing_page.dart';
import 'package:gdsc/service/backend_api.dart';
import 'package:gdsc/service/get_today.dart';
import 'package:gdsc/widget/floating_point.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              Provider.of<FolderPageProvider>(context, listen: false)
                  .listFilesAndTexts();
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

  Future<void> test() async {
    var response = await ping();
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
    } else {
      print('Failed to ping: ${response.body}');
      Get.offAll(LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    test();
    return Scaffold(
      floatingActionButton: floatingInHomePage(context),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Consumer<FolderPageProvider>(builder: (context, data, child) {
          List<FileSystemEntity> files = data.files;
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 44.0),
                margin: const EdgeInsets.only(left: 16.0, top: 44.0),
                child: const Text(
                  'Archivit',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 50.0,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 15.0)),
                  const Divider(
                    color: Color.fromARGB(50, 118, 118, 128),
                    thickness: 0.5,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 1.0),
                    child: Text(
                      '📝️ Learn more about Archivit!',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      'Thank you for using our app! Our team created this app with ...',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      // today date
                      getToday(),
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const Divider(
                    //Colors.grey[200]
                    // color: Color(0xFFF2F8F8),
                    color: Color.fromARGB(50, 118, 118, 128),
                    thickness: 8,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Wrap(
                  spacing: 17,
                  runSpacing: 19.0,
                  children: files.map((file) {
                    String ext = path.extension(file.path);

                    if (ext == '.m4a') {
                      return GestureDetector(
                        onLongPress: () {
                          showEditDialog(file);
                        },
                        onTap: () {
                          // Open the file todo
                          Get.to(() => VoiceTextScreen());
                        },
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 92,
                              width: 108,
                              child: Icon(
                                Icons.audiotrack,
                                size: 50,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              file.path.split('/').last,
                              style: const TextStyle(
                                fontSize: 13.0,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              file
                                  .statSync()
                                  .modified
                                  .toLocal()
                                  .toString()
                                  .split('.')[0],
                              style: const TextStyle(
                                fontSize: 9.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (ext == '.json' || ext == '.txt') {
                      return GestureDetector(
                        onLongPress: () {
                          showEditDialog(file);
                        },
                        onTap: () {
                          // Open the file todo
                        },
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 92,
                              width: 108,
                              child: Icon(
                                Icons.article,
                                size: 50,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              file.path.split('/').last,
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              file
                                  .statSync()
                                  .modified
                                  .toLocal()
                                  .toString()
                                  .split('.')[0],
                              style: const TextStyle(
                                fontSize: 9.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onLongPress: () {
                          showEditDialog(file);
                        },
                        onTap: () {
                          // Open the file
                          Provider.of<FolderPageProvider>(context,
                                  listen: false)
                              .setSelectedFile(file);
                          Get.to(() => InFolderPage());
                        },
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 92,
                              width: 108,
                              child: Image(
                                image: AssetImage('assets/icon/folder.jpg'),
                              ),
                            ),
                            Text(
                              file.path.split('/').last,
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              file
                                  .statSync()
                                  .modified
                                  .toLocal()
                                  .toString()
                                  .split('.')[0],
                              style: const TextStyle(
                                fontSize: 9.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }).toList(),
                ),
              )
            ],
          );
        }),
      ),
      bottomNavigationBar: BottomBarRoutingPage(),
    );
  }
}
