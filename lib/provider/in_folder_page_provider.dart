import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class InFolderPageProvider extends ChangeNotifier {
  List<FileSystemEntity> get files => _files;
  List<FileSystemEntity> _files = [];

  Future<void> listFilesAndTexts(String path) async {
    // Get the app document directory path
    final directory = await getApplicationDocumentsDirectory();
    final folder = Directory('${directory.path}/$path');

    _files = folder.listSync();
    notifyListeners();
  }
}
