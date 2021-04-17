import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  static const _apiKey = 'AIzaSyAPGyTgl4ve28ARcvpLDUwOcQLzVH7EX2c';

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$_apiKey';

    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    print(json.decode(response.body));
    return Future.value();
  }

  Future<void> signUp(String email, String password) =>
      _authenticate(email, password, 'signUp');

  Future<void> login(String email, String password) =>
      _authenticate(email, password, 'signInWithPassword');
}
