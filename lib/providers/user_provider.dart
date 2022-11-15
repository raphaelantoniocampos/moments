import 'package:flutter/material.dart';
import 'package:moments/constants.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier{
  User? _user;


  User? get getUser => _user;

  Future<void> refreshUser() async {
    User user = await authController.getUserDetails();
    _user = user;
    notifyListeners();
  }
}