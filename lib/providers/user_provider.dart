import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier{
  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {

  }
}