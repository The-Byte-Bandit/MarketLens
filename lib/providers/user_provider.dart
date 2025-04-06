import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  final SharedPreferences prefs;
  String? _name;
  String? _email;

  UserProvider(this.prefs) {
    _name = prefs.getString('userName');
    _email = prefs.getString('userEmail');
  }

  String? get name => _name;
  String? get email => _email;

  void setUser(String name, String email) {
    _name = name;
    _email = email;
    prefs.setString('userName', name);
    prefs.setString('userEmail', email);
    notifyListeners();
  }
}