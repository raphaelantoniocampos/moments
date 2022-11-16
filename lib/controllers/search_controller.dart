import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../models/post.dart';
import '../models/user.dart';

class SearchController extends GetxController {
  final Rx<List<User>> _searchedUsers = Rx<List<User>>([]);
  final Rx<List<Post>> _publicPostList = Rx<List<Post>>([]);

  List<User> get searchedUsers => _searchedUsers.value;

  List<Post> get publicPostList => _publicPostList.value;
  RxBool showUsers = false.obs;

  @override
  void onInit() {
    _publicPostList.bindStream(
      firebaseFirestore
          .collection('posts')
          .where('isPublic', isEqualTo: true)
          .orderBy('datePublished', descending: true)
          .snapshots()
          .map((QuerySnapshot query) {
        List<Post> retValue = [];
        for (var element in query.docs) {
          retValue.add(Post.fromSnap(element));
        }
        return retValue;
      }),
    );
    super.onInit();
  }

  searchUser(String typedUser) async {
    _searchedUsers.bindStream(
      firebaseFirestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: typedUser)
          .snapshots()
          .map((QuerySnapshot query) {
        List<User> retVal = [];
        for (var elem in query.docs) {
          retVal.add(User.fromSnap(elem));
        }
        return retVal;
      }),
    );
  }
}
