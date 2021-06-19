import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/data/store.dart';

import '../exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  static const _apiKey = 'AIzaSyAPGyTgl4ve28ARcvpLDUwOcQLzVH7EX2c';
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _logoutTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return isAuth ? _userId : null;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

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

    final responseBody = json.decode(response.body);

    if (responseBody['error'] != null) {
      throw AuthException(responseBody['error']['message']);
    } else {
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody['expiresIn']),
        ),
      );

      // Salvando os dados do usuário no shared preferences para futuramente fazer um auto
      // login com os dados armazenados
      Store.saveMap('userData', {
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate
            .toIso8601String(), // Salva a data num formato fácil de fazer o parse reverso
      });

      // chama o comportamento de logout automático assim que o login do usuário é confirmado
      _autoLogout();
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> signUp(String email, String password) =>
      _authenticate(email, password, 'signUp');

  Future<void> login(String email, String password) =>
      _authenticate(email, password, 'signInWithPassword');

  Future<void> tryAutoLogin() async {
    // não continua o processo se o usuário já estiver autenticado
    if (isAuth) {
      return Future.value();
    }

    // Obtendo as informações de login através da Store
    final userData = await Store.getMap('userData');

    // Se não houverem informações de login salvas, não continua o processo
    if (userData == null) {
      return Future.value();
    }

    final expiryDate = DateTime.parse(userData['expiryDate']);

    // Verificando se a data recebida é válida
    if (expiryDate.isBefore(DateTime.now())) {
      // Se for uma data anterior a data atual, não é válido!
      return Future.value();
    }

    _userId = userData['userId'];
    _token = userData['token'];
    _expiryDate = expiryDate;

    // Inicia o processo de auto logout
    _autoLogout();
    notifyListeners();
    return Future.value();
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;

    /* Garantindo que o timer será cancelado quando o usuário
    fizer um logout*/
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
      _logoutTimer = null;
    }

    // Quando um logout é feito, as chaves para os dados de autenticação são removidas
    Store.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    if (_logoutTimer != null) {
      /* Na criação do timer, se o mesmo não estiver inativo
      ele (que é o timer mais antigo) será cancelado para que
      não ocorra de mais de um timer rodar em paralelo
       */
      _logoutTimer.cancel();
    }

    /* Calculando um tempo para que o logout seja feito */
    final timeToLogout = _expiryDate.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout), logout);
  }
}
