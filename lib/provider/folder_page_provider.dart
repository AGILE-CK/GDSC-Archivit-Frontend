import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FolderPageProvider extends ChangeNotifier {
  List<FileSystemEntity> get files => _files;
  List<FileSystemEntity> _files = [];
  Future<void> listFilesAndTexts() async {
    // Get the app document directory path
    final directory = await getApplicationDocumentsDirectory();
    _files = directory.listSync();
    notifyListeners();
  }
}
