import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:moments/constants.dart';

import '../models/user.dart';

class ProfileController extends GetxController{
late Rx<User> _user;
User get user => _user.value;

 Rx<String> _uid = "".obs;
updateUserId(String uid) {
  _uid.value = uid;
  getUserData();
}

getUserData() async{
  DocumentSnapshot userDoc = await firebaseFirestore.collection('users').doc(_uid.value).get();
  final data = userDoc.data()! as dynamic;
  _user.value = User.fromSnap(data);

  update();
}


}