import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/post.dart';
import '../constants.dart';

class PostController extends GetxController {
  final Rx<List<Post>> _postList = Rx<List<Post>>([]);

  List<Post> get postList => _postList.value;

  @override
  void onInit() {
    _postList.bindStream(
      firebaseFirestore
          .collection('posts')
          .snapshots()
          .map((QuerySnapshot query) {
        List<Post> retValue = [];
        for (var element in query.docs) {
          retValue.add(
              Post.fromSnap(element));
          print(Post.fromSnap(element));
        }
        return retValue;
      }),
    );
    super.onInit();
  }
}
