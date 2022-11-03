import 'package:flutter/material.dart';
import 'package:moments/controllers/auth_controller.dart';
import 'package:moments/controllers/constants.dart';

import '../models/user.dart';
import '../resources/auth_methods.dart';

class UserProvider with ChangeNotifier{
  User? _user;


  User? get getUser => _user;

  Future<void> refreshUser() async {
    User user = await authController.getUserDetails();
    _user = user;
    notifyListeners();
  }
}