import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:moments/models/comment.dart';
import 'package:path_provider/path_provider.dart';
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

  FlutterSoundRecorder? _recorder;
  String? _path;
  bool _isRecording = false;
  String? _audioUrl;

  bool get isRecording => _isRecording;


  String _postId = "";

  Future<void> startRecording() async {
    var tempDir = await getTemporaryDirectory();
    _path = '${tempDir.path}/comment_sound.aac';
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
    await _recorder!.startRecorder(toFile: _path);
    _isRecording = true;
    update();
  }

  Future<void> stopRecording() async {
    _audioUrl = null;
    _isRecording = false;
    update();
    await _recorder!.stopRecorder();
    await _recorder!.closeRecorder();
  }

  Future <String> uploadCommentToStorage(String path,String postId, String id) async {
    final Reference reference = firebaseStorage.ref().child('comments').child(postId).child(id);
    final metadata = SettableMetadata(
        contentType: 'audio/mp3',
        customMetadata: {'picked-file-path': path});
    final TaskSnapshot taskSnapshot = await reference.putFile(File(path), metadata);
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;

  }

  postComment(String postId) async {
    try {
      if (_path!.isNotEmpty) {
        String id = const Uuid().v1();
        final String audioUrl = await uploadCommentToStorage(_path!, postId, id);
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
