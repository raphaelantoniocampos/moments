import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import 'constants.dart';
import 'package:moments/models/user.dart' as model;

class ProfilePicController extends GetxController{

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

  //upload to firebase firestore
  Future<void> uploadProfilePic(File image) async {
    String res;
    var collection = firebaseFirestore.collection('users');
    model.User user = await authController.getUserDetails();
    String downloadUrl = await _uploadToStorage(image);
    user.profilePic = downloadUrl;
    Map<String, Object?> data = user.toJson();
    collection
        .doc(firebaseAuth.currentUser!.uid)
        .update(data);
  }


}