import 'package:flutter/material.dart';

class MakeTextFilePageProvider extends ChangeNotifier {
  String _text = ''; // text to be saved in the file todo
  String get text => _text;

  void setText(String text) {
    _text = text;
    notifyListeners();
  }
}
