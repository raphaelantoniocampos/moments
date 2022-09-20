import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    // required Uint8List file,
  }) async {
    String res = "Some error occoured";
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty
          // && file != null
          ) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // add user to database
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'friends': [],
        });
        print(cred.user!.uid);
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
