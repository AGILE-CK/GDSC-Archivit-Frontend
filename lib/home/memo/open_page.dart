import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdsc/provider/folder_page_provider.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class OpenFilePage extends StatefulWidget {
  final String filePath;

  OpenFilePage({required this.filePath});

  @override
  _OpenFilePage createState() => _OpenFilePage();
}

class _OpenFilePage extends State<OpenFilePage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readTextFile(widget.filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text(
          "File Content",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveTextFile(widget.filePath, context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _textEditingController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _readTextFile(String path) async {
    final File file = File('$path');

    if (await file.exists()) {
      _textEditingController.text = await file.readAsString();
    } else {
      _textEditingController.text = "File does not exist";
    }

    setState(() {});
  }

  Future<void> _saveTextFile(String path, context) async {
    final File file = File('$path');
    await file.writeAsString(_textEditingController.text);
    Provider.of<FolderPageProvider>(context, listen: false).listFilesAndTexts();
    Get.back();
  }
}
