import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../constants.dart';
import 'package:moments/models/user.dart' as model;

class ProfilePicController extends GetxController{
  static ProfilePicController instance = Get.find();

  //upload image to firebase storage

  // Future<String> _uploadToStorage(File image) async {
  //   Reference ref = firebaseStorage
  //       .ref()
  //       .child('profilePic')
  //       .child(firebaseAuth.currentUser!.uid);
  //   UploadTask uploadTask = ref.putFile(image);
  //   TaskSnapshot snap = await uploadTask;
  //   String downloadUrl = await snap.ref.getDownloadURL();
  //   return downloadUrl;
  // }

  //get storage picture
  Future<String> _getDownloadUrl(String id) async {
    String downloadUrl = await firebaseStorage
        .ref()
        .child('posts')
        .child(firebaseAuth.currentUser!.uid)
        .child(id).getDownloadURL();
    return downloadUrl;
  }


  //upload to firebase firestore
  Future<void> changeProfilePic(String downloadUrl) async {
    String res = '';
    try {
      var collection = firebaseFirestore.collection('users');
      model.User user = await authController.getUserDetails();
      user.profilePic = downloadUrl;
      Map<String, Object?> data = user.toJson();
      collection
          .doc(firebaseAuth.currentUser!.uid)
          .update(data);
      res = 'Success';
    }
    catch(e){
      res = e.toString();
      Get.snackbar("Change Profile Pic", res);
    }
  }


}