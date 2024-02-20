import 'dart:convert';

import 'package:gdsc/service/token_function.dart';
import 'package:http/http.dart' as http;

const String URL =
    "https://agile-dev-dot-primeval-span-410215.du.r.appspot.com/";

const String SIGNUP = "auth/signup";
const String LOGIN = "auth/login";
const String GOOGLE_LOGIN = "auth/google/login";

const String PING = "ping";

const String FILE_DELETE = "file/delete";
const String TEXT_CREATE = "text/create";
const String RECORD_CREATE = "record/create";

const String GOOGLECLIENTID =
    '584965141712-eku96vnto2vr7t4bk584kkf7q4mer4hn.apps.googleusercontent.com';
Future<http.Response> signUp(String email, String password) async {
  var url = Uri.parse(URL + SIGNUP);

  return await http.post(
    url,
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
    headers: {'Content-Type': 'application/json'},
  );
}

//Login
Future<http.Response> login(String email, String password) async {
  var url = Uri.parse(URL + LOGIN);

  return await http.post(
    url,
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
    headers: {'Content-Type': 'application/json'},
  );
}

//ping with jwt token
Future<http.Response> ping() async {
  var url = Uri.parse(URL + PING);
  var token = await getToken();
  token = jsonDecode(token)['token'];

  return await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  });
}

Future<http.Response> uploadRecording(String filePath) async {
  var url = Uri.parse(URL + RECORD_CREATE);
  var token = await getToken();
  token = jsonDecode(token)['token'];
  var request = http.MultipartRequest('POST', url)
    ..headers['Authorization'] = 'Bearer $token'
    ..files.add(await http.MultipartFile.fromPath('file', filePath));
  var streamedResponse = await request.send();
  return http.Response.fromStream(streamedResponse);
}

Future<http.Response> uploadText(String filePath) async {
  var url = Uri.parse(URL + TEXT_CREATE);
  var token = await getToken();
  token = jsonDecode(token)['token'];
  var request = http.MultipartRequest('POST', url)
    ..headers['Authorization'] = 'Bearer $token'
    ..files.add(await http.MultipartFile.fromPath('file', filePath));
  var streamedResponse = await request.send();
  return http.Response.fromStream(streamedResponse);
}

Future<http.Response> deleteFile(String filePath) async {
  var url = Uri.parse(URL + FILE_DELETE);
  var token = await getToken();
  token = jsonDecode(token)['token'];
  return await http.delete(
    url,
    body: jsonEncode(<String, String>{
      'file': filePath,
    }),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
}
