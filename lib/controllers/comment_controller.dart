import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:moments/models/comment.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);
  List<dynamic> _commentUidList = [];

  List<Comment> get comments => _comments.value;

  List get commentUidList => _commentUidList;

  set setCommentUidList(List<dynamic> value) {
    _commentUidList = value;
  }

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

  updateCommentLikes(Comment comment) {
    if (comment.likes.isNotEmpty) {
      setCommentUidList = [];
    }
    for (var uid in comment.likes) {
      commentUidList.add(uid);
    }
  }

  Future <String> uploadCommentToStorage(String path, String id) async {
    final Reference reference = firebaseStorage.ref().child('comments').child(id);
    final TaskSnapshot taskSnapshot = await reference.putFile(File(path));
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;

  }

  postComment(String path) async {
    try {
      if (path.isNotEmpty) {
        String id = const Uuid().v1();
        final String audioUrl = await uploadCommentToStorage(path, id);
        Comment comment = Comment(
            uid: authController.user.uid,
            id: id,
            audioUrl: audioUrl,
            datePublished: DateTime.now(),
            likes: [],
            // duration: duration,
        );

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
      // print('Error while commenting ${e.toString()}');
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
