import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:mime/mime.dart';

import '../models/post.dart';
import '../constants.dart';

class PostController extends GetxController {
  Future<List<Post>> get postList async {
    List friends = await getUserFriends();
    QuerySnapshot query = await firebaseFirestore
        .collection('posts')
        .where('uid', whereIn: friends)
        .orderBy('datePublished', descending: true)
        .get();
    List<Post> retValue = [];
    for (var element in query.docs) {
      retValue.add(Post.fromSnap(element));
    }
    return retValue;
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<String>> getUserFriends() async {
    DocumentSnapshot userDoc = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    final userData = userDoc.data()! as dynamic;
    List<String> friends = List<String>.from(userData['friends']);
    return friends;
  }

  likePost(String postId) async {
    DocumentSnapshot doc =
        await firebaseFirestore.collection('posts').doc(postId).get();
    var uid = authController.user.uid;
    var liked = (doc.data()! as dynamic)['likes'].contains(uid);

    if (liked) {
      await firebaseFirestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await firebaseFirestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  Future<void> deletePost(String postId) async {
    String res = '';
    try {
      await firebaseFirestore.collection('posts').doc(postId).delete();
      res = 'Post deleted';
    } catch (err) {
      res = err.toString();
    }
    Get.snackbar("Delete", res);
  }

  Future<void> changeDescription(String postId, String description) async {
    try {
      var snap = await firebaseFirestore.collection('posts').doc(postId).get();
      Post post = Post.fromSnap(snap);
      post.description = description;
      Map<String, Object?> data = post.toJson();
      firebaseFirestore.collection('posts').doc(postId).update(data);
    } catch (e) {
      Get.snackbar("Change Description", e.toString());
    }
  }

  _compressVideo(String path) async {
    final compressedVideo = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.HighestQuality,
    );
    return compressedVideo!.file;
  }

  Future<String> _uploadFileToStorage(
      String childName, String path, String id, bool isVideo) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid)
        .child(id);

    if (isVideo) {
      UploadTask uploadTask = ref.putFile(await _compressVideo(path));
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } else {
      UploadTask uploadTask = ref.putFile(File(path));
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    }
  }

  Future<String> _uploadThumbnailToStorage(
      String childName, String id, String path) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid)
        .child(id);

    UploadTask uploadTask = ref.putFile(await _getThumbnail(path));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String path) async {
    final thumbnail = await VideoCompress.getFileThumbnail(path);
    return thumbnail;
  }

  Future<Post?> uploadPost(File file) async {
    String res = '';
    try {
      String path = file.path;
      bool isVideo = lookupMimeType(path) == 'video/mp4';

      String id = const Uuid().v1();
      String uid = firebaseAuth.currentUser!.uid;
      String downloadUrl =
          await _uploadFileToStorage('posts', path, id, isVideo);
      String thumbnail = '';
      if (isVideo) {
        thumbnail = await _uploadThumbnailToStorage('thumbnails', id, path);
      }
      Post post = Post(
          description: '',
          uid: uid,
          postId: id,
          datePublished: DateTime.now(),
          downloadUrl: downloadUrl,
          likes: [],
          isVideo: isVideo,
          thumbnail: thumbnail,
          isPublic: false,
          commentCount: 0);

      await firebaseFirestore.collection('posts').doc(id).set(
            post.toJson(),
          );
      res = 'Success';
      return post;
    } catch (e) {
      res = e.toString();
    }
    Get.snackbar('Upload Post', res);
    return null;
  }

  void makePublic(String postId) async {
    try {
      var snap = await firebaseFirestore.collection('posts').doc(postId).get();
      Post post = Post.fromSnap(snap);
      if (post.isPublic) {
        post.isPublic = false;
        Map<String, Object?> data = post.toJson();
        firebaseFirestore.collection('posts').doc(postId).update(data);
      } else {
        post.isPublic = true;
        Map<String, Object?> data = post.toJson();
        firebaseFirestore.collection('posts').doc(postId).update(data);
      }
    } catch (e) {
      Get.snackbar("Make public", e.toString());
    }
  }
}
