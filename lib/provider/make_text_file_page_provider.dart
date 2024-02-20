import 'package:flutter/material.dart';

class MakeTextFilePageProvider extends ChangeNotifier {
  String _path = ''; // todo

  String get path => _path;

  void setPath(String path) {
    _path = path;
    notifyListeners();
  }
}
