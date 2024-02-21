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
    if (decodedJson['violence_status'] == "Violent Situation Detected") {
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

Future<Map<String, dynamic>> transcribeFile(File file) async {
  var url = Uri.parse(URL + transcribe);

  var request = http.MultipartRequest('POST', url);
  request.headers['accept'] = 'application/json';
  request.files.add(await http.MultipartFile.fromPath('file', file.path,
      contentType: MediaType('audio', 'x-m4a')));

  var response = await request.send();

  var responseBody = await response.stream.bytesToString();
  print(responseBody);

  Map<String, dynamic> decodedJson = jsonDecode(responseBody);
  if (response.statusCode != 200) {
    throw Exception('Failed to load transcript');
  }
  return decodedJson;
}

// curl -X 'POST' \
//   'https://final-apcfknrtba-du.a.run.app/summarize/' \
//   -H 'accept: application/json' \
//   -H 'Content-Type: application/json' \
//   -d '{
//   "prompt_parts": [
//     "SPEAKER_00: 안녕 준하야 오늘 어떻게 지냈어?\nSPEAKER_01: 어.. 잘 지냈어. 너는?\nSPEAKER_00: 나? 나도 잘 지냈어. 오늘 뭐 했는데?\nSPEAKER_01: 오늘 아무것도 안 했어\nSPEAKER_00: 아 그래? 밖에 나가서 사람 좀 만나고 그래\n"
//   ]
// }
// '

Future<String> summarizeJson(Map<String, dynamic> transcript) async {
  String requestBody = '';

  for (var item in transcript['transcriptions']) {
    String speaker = item[0];
    String text = item[1];
    requestBody += speaker + ": " + text + "\n";
  }
  var url = Uri.parse(URL + SUMMARIZE);

  var response = await http.post(
    url,
    headers: <String, String>{
      'accept': 'application/json',
      'Content-Type': 'application/json; charset=utf-8' // 여기를 수정했습니다.
    },
    body: jsonEncode(<String, dynamic>{
      'prompt_parts': [requestBody]
    }),
  );

  print(response.body);

  String body = utf8.decode(response.bodyBytes);

  if (response.statusCode != 200) {
    throw Exception('Failed to load summary');
  }
  return jsonDecode(body)['generated_text'];
}
