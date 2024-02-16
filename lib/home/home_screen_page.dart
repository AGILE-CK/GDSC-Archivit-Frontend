import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdsc/provider/folder_page_provider.dart';
import 'package:gdsc/routing/bottom_bar_routing_page.dart';
import 'package:gdsc/service/get_today.dart';
import 'package:gdsc/widget/floating_point.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

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
          file.renameSync(controller.text.trim());
          Get.back(); // Close the dialog
          Provider.of<FolderPageProvider>(context, listen: false)
              .listFilesAndTexts();
          setState(() {}); // Redraw the screen
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingInHomePage(context),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Consumer<FolderPageProvider>(builder: (context, data, child) {
          List<FileSystemEntity> files = data.files;
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16.0, top: 44.0),
                child: const Text(
                  'Archivit',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: Color(0xFF3C3C43),
                        size: 20.0,
                      ),
                      SizedBox(width: 4.0),
                      const Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 16.0),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            isDense: true,
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Implement voice input functionality
                        },
                        child: const Icon(
                          Icons.mic,
                          color: Color(0xFF3C3C43),
                          size: 20.0,
                        ),
                      ),
                    ],
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
                    return GestureDetector(
                      onLongPress: () {
                        showEditDialog(file);
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
