import 'dart:convert';
import 'dart:io';

import 'package:gdsc/service/preference_function.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

const String URL = "https://final-apcfknrtba-du.a.run.app/";
// const String URL = "http://127.0.0.1:8000/";

const String SUMMARIZE = "summarize/";
const String VIOLENT = "violent-speech-detection/";
const String CLAM = "clam-situation-detection/";
const String transcribe = "transcribe/";

Future<bool> violent(File file) async {
  var url = Uri.parse(URL + VIOLENT);

  var request = http.MultipartRequest('POST', url);
  request.headers['accept'] = 'application/json';

  request.files.add(await http.MultipartFile.fromPath('file', file.path,
      contentType: MediaType('audio', 'm4a')));

  var response = await request.send();

  var responseBody = await http.Response.fromStream(response);
  print(responseBody.body);

  Map<String, dynamic> decodedJson = jsonDecode(responseBody.body);

  if (response.statusCode == 200) {
    if (decodedJson['violance_status'] == "Violent Situation Detected") {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<bool> clam(File file) async {
  var url = Uri.parse(URL + CLAM);

  var request = http.MultipartRequest('POST', url);
  request.headers['accept'] = 'application/json';
  request.files.add(await http.MultipartFile.fromPath('file', file.path,
      contentType: MediaType('audio', 'x-m4a')));

  var response = await request.send();

  var responseBody = await http.Response.fromStream(response);
  print(responseBody.body);

  Map<String, dynamic> decodedJson = jsonDecode(responseBody.body);

  if (response.statusCode == 200) {
    if (decodedJson['situation'] == "Calm Situation" ||
        decodedJson['situation'] == "Default Situation") {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<void> transcribeFile(File file) async {
  var url = Uri.parse(URL + transcribe);

  var request = http.MultipartRequest('POST', url);
  request.headers['accept'] = 'application/json';
  request.files.add(await http.MultipartFile.fromPath('file', file.path,
      contentType: MediaType('audio', 'x-m4a')));

  var response = await request.send();

  var responseBody = await http.Response.fromStream(response);
  print(responseBody.body);

  Map<String, dynamic> decodedJson = jsonDecode(responseBody.body);

  if (response.statusCode == 200) {
    print(decodedJson['transcription']);
  } else {
    print("Error");
  }
}
