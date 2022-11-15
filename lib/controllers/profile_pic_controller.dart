import 'package:get/get.dart';

import '../constants.dart';
import 'package:moments/models/user.dart' as model;

import '../models/post.dart';

class ProfilePicController extends GetxController{
  static ProfilePicController instance = Get.find();

  Future<void> changeProfilePic(Post post) async {
    String res = '';
    try {
      var collection = firebaseFirestore.collection('users');
      model.User user = await authController.getUserDetails();
      String imageUrl;
      print('print erro 1');
      if(post.isVideo){
        imageUrl = post.thumbnail;
      }
      else{
        imageUrl = post.downloadUrl;
      }
      print('print erro 2');
      user.profilePic = imageUrl;
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