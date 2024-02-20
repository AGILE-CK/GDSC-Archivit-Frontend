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

// //Google login
// Future<http.Response> googleLogin() async {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     clientId: GOOGLECLIENTID,
//   );

//   // Google 로그인을 수행합니다.
//   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//   // 로그인에 성공하면 Google 로그인 세션의 ID 토큰을 가져옵니다.
//   final String? idToken = (await googleUser!.authentication).idToken;

//   // 서버에 로그인 요청을 보냅니다.
//   var url = Uri.parse(URL + GOOGLE_LOGIN);
//   return await http.post(url, body: {'idtoken': idToken});
// }
