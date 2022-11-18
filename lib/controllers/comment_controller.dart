import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:moments/models/comment.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);

  List<Comment> get comments => _comments.value;

  String _postId = "";

  updatePostId(String id) {
    _postId = id;
    getComments();
  }

  getComments() async {
    _comments.bindStream(firebaseFirestore
        .collection('posts')
        .doc(_postId)
        .collection('comments')
        .orderBy('datePublished', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Comment> commentList = [];
      for (var element in query.docs) {
        commentList.add(Comment.fromSnap(element));
      }
      return commentList;
    }));
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        String id = const Uuid().v1();
        Comment comment = Comment(
            uid: authController.user.uid,
            id: id,
            text: commentText.trim(),
            datePublished: DateTime.now(),
            likes: []);

        await firebaseFirestore
            .collection('posts')
            .doc(_postId)
            .collection('comments')
            .doc(id)
            .set(comment.toJson());

        DocumentSnapshot doc =
            await firebaseFirestore.collection('posts').doc(_postId).get();
        await firebaseFirestore.collection('posts').doc(_postId).update({
          'commentCount': (doc.data()! as dynamic)['commentCount'] + 1,
        });

        // getComments();
        // getUsers();
      }
    } catch (e) {
      Get.snackbar('Error while commenting', e.toString());
    }
  }

  likeComment(String commentId) async {
    var uid = authController.user.uid;
    DocumentSnapshot doc = await firebaseFirestore
        .collection('posts')
        .doc(_postId)
        .collection('comments')
        .doc(commentId)
        .get();

    if ((doc.data()! as dynamic)['likes'].contains(uid)) {
      await firebaseFirestore
          .collection('posts')
          .doc(_postId)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await firebaseFirestore
          .collection('posts')
          .doc(_postId)
          .collection('comments')
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }
}
