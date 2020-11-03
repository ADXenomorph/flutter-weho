import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:weho/main.dart';
import 'package:weho/src/services/storage.service.dart';

class AuthService {
  static String token;

  StorageService storageService = StorageService();
  Client _client = Client();

  Future<dynamic> login(String email, String password) async {
    final res = await _client.post(
      "$baseUrl/api/auth/login",
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'remember': "1"
      })
    );

    print(res.statusCode);
    print(res.body);

    if (res.statusCode == 201) {
      var jsonBody = json.decode(res.body);
      token = jsonBody['token']['accessToken'];
      print(token);
      StorageService().saveToken(token);

      return jsonBody;
    }

    return null;
  }

  Future<void> logout() {
    return StorageService().deleteToken();
  }

  bool isLoggedIn() {
    return token != null;
  }
}