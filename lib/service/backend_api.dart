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

//{"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Inp6ejU0MjEzMEBuYXZlci5jb20iLCJleHAiOjE3MDgzNTkwNDZ9.atFvBuEA6rt4YWg7g0UAUoANdyNes0lN6E95opN8qvg"}

  token = jsonDecode(token)['token'];

  return await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  });
}

// if (response.statusCode == 401) {

//     Get.to(LoginPage());
//   }
