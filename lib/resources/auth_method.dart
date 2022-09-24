import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moments/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required Uint8List file,
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
        print('print file - auth method: $file');

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        // add user to database
        await _fireStore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'friends': [],
          'photoUrl' : photoUrl,
        });
        print(cred.user!.uid);
        res = "Success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
