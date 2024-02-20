import 'package:flutter/material.dart';

class MakeFilePageProvider extends ChangeNotifier {
  String _path = ''; // todo
  String _fileName = '';

  String get path => _path;
  String get fileName => _fileName;

  String get fullPath {
    if (_path.isEmpty) return _fileName;
    return '$_path/$_fileName';
  }

  int _index = 0;
  // 0 -> open txt
  // 1 -> make blank
  // 2 -> make school
  // 3 -> make domestic
  // 4 -> make dating
  // voice is any

  int get index => _index;

  void setPath(String path) {
    _path = path;
    notifyListeners();
  }

  void setFileName(String fileName) {
    _fileName = fileName;
    notifyListeners();
  }
}
