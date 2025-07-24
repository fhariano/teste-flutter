import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService with ChangeNotifier {
  bool rememberMe = false;

  Future initRememberedCredentials(
    TextEditingController cpf,
    TextEditingController password,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    rememberMe = prefs.getBool('rememberMe') ?? false;
    print('bool rememberMe: $rememberMe');
    if (rememberMe) {
      cpf.text = prefs.getString('cpf') ?? '';
      password.text = prefs.getString('password') ?? '';
      print('passei rememberMe');
    }
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    rememberMe = value;
    print('passei toggleRememberMe: $rememberMe');
    notifyListeners();
  }

  Future<void> saveCredentialsIfNeeded(String cpf, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      print('passei save...');
      await prefs.setBool('rememberMe', true);
      await prefs.setString('cpf', cpf);
      await prefs.setString('password', password);
    } else {
      print('passei remove...');
      await prefs.remove('rememberMe');
      await prefs.remove('cpf');
      await prefs.remove('password');
    }
  }
}
