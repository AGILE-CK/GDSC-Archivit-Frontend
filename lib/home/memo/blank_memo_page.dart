import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdsc/provider/folder_page_provider.dart';
import 'package:gdsc/provider/make_file_page_provider.dart';
import 'package:gdsc/service/backend_api.dart';
import 'package:gdsc/service/get_default_directory.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class BlankMemoPage extends StatefulWidget {
  @override
  _BlankMemoPageState createState() => _BlankMemoPageState();
}

class _BlankMemoPageState extends State<BlankMemoPage> {
  final TextEditingController _textEditingController = TextEditingController(
    text: "",
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<MakeFilePageProvider>(
        builder: (context, makeTextFilePageProvider, child) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: () {
                _saveTextFile(makeTextFilePageProvider.fullPath, context);
                Get.back();
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Text(
                  "Done",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              size: 30.0,
              color: Colors.black,
            ),
          ),
          title: Text(
            makeTextFilePageProvider.fileName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: TextField(
                    controller: _textEditingController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _saveTextFile(String path, context) async {
    final Directory directory = await createUserDataDirectory();

    final File file = File('${directory.path}/$path.txt');
    Provider.of<FolderPageProvider>(context, listen: false).listFilesAndTexts();
    await file.writeAsString(_textEditingController.text);
    var response = await uploadText(file.path);
  }
}
