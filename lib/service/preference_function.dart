import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> setToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token') ?? "";
  return token;
}

Future<void> saveTrascriptJSON(
    Map<String, dynamic> jsonMap, String path) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('$path', json.encode(jsonMap));
}

Future<Map<String, dynamic>> getTranscriptJSON(String path) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonMap = prefs.getString('$path');
  if (jsonMap == null) {
    return {};
  }
  return json.decode(jsonMap);
}
