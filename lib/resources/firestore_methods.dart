import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moments/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload post
  // Future<String> uploadPost(
  //     Uint8List file,
  //     String uid,
  //     bool isVideo) async {
  //   String res = "some error ocurred";
  //   try {
  //     String photoUrl =
  //         await StorageMethods().uploadFileToStorage('posts', file);
  //
  //     String postId = const Uuid().v1();
  //
  //     Post post = Post(
  //         description: '',
  //         uid: uid,
  //         postId: postId,
  //         datePublished: DateTime.now(),
  //         postUrl: photoUrl,
  //         likes: [],
  //         isVideo: isVideo,
  //         isPublic: false, thumbnail: '', commentCount: 0);
  //
  //     _firestore.collection('posts').doc(postId).set(post.toJson());
  //     res = 'Success';
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      print('likePost error: ${err.toString()}');
    }
  }

  Future<String> postComment(String uid, String postId, String text) async {
    String res = '';
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          // 'user' : user,
          'uid': uid,
          'postId': postId,
          'text': text,
          'commentId': commentId,
          'likes': [],
          'datePublished': DateTime.now(),
        });
        res = 'Posted';
      } else {
        res = 'Text is empty';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likeComment(
      String postId, String uid, String commentId, List likes) async {
    try {
      if (likes.contains(uid)) {
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      print('likePost error: ${err.toString()}');
    }
  }

  Future<String> deletePost(String postId) async {
    String res = '';
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'Post deleted';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> addFriend(String uid, String friendId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List friends = (snap.data()! as dynamic)['friends'];
      if (friends.contains(friendId)) {
        await _firestore.collection('users').doc(friendId).update({
          'friends': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'friends': FieldValue.arrayRemove([friendId])
        });
      } else {
        await _firestore.collection('users').doc(friendId).update({
          'friends': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'friends': FieldValue.arrayUnion([friendId])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }
}
