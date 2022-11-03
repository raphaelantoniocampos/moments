import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:moments/models/user.dart' as model;
import 'constants.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  //upload image to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePic')
        .child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  //registering the user
  void registerUser(String username, String email, String password) async {
    String res;
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        //save user to auth and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        // String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
            profilePic:
                'https://firebasestorage.googleapis.com/v0/b/moments-a47d4.appspot.com/o/model%2FinitialProfilePic.jpg?alt=media&token=05c1a014-b453-4ba7-a1fb-fd2e4ade68db',
            uid: cred.user!.uid,
            username: username,
            connecting: [],
            connections: [],
            email: email);
        await firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = 'Success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    Get.snackbar('Creating account', res);
  }
}
