import 'package:flutter/material.dart';

class MakeTextFilePageProvider extends ChangeNotifier {
  String _text = ''; // todo

  String get text => _text;

  void setText(String text) {
    _text = text;
    notifyListeners();
  }
}
