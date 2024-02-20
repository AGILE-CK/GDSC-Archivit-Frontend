import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdsc/service/get_default_directory.dart';
import 'package:path_provider/path_provider.dart';

class FolderPageProvider extends ChangeNotifier {
  List<FileSystemEntity> get files => _files;
  List<FileSystemEntity> _files = [];

  FileSystemEntity get selectedFile => _selectedFile;
  late FileSystemEntity _selectedFile;

  Future<void> listFilesAndTexts() async {
    // Get the app document directory path
    final directory = await createUserDataDirectory();
    _files = directory.listSync();
    notifyListeners();
  }

  void setSelectedFile(FileSystemEntity file) {
    _selectedFile = file;
    notifyListeners();
  }
}
