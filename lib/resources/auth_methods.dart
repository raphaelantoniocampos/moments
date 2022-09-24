import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moments/models/user.dart' as model;
import 'package:moments/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = (await _fireStore.collection('users').doc(currentUser.uid).get());

    return model.User.fromSnap(snap);
  }


  //sign up user
  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required Uint8List file,
  }) async {
    String res = "Some error occoured";
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty
          // && file != null
          ) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print('print file - auth method: $file');

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
            photoUrl: photoUrl,
            uid: cred.user!.uid,
            username: username,
            friends: [],
            email: email);

        // add user to database
        await _fireStore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "Success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  //login user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'some error occured';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Success';
      } else {
        res = 'Please enter all the fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        res = 'Wrong password';
      }
      if (e.code == 'invalid-email') {
        res = 'Invalid email';
      }
      if (e.code == 'user-not-found') {
        res = 'User not found';
      }
      print(e.code);
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
