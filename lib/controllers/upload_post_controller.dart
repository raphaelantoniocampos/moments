import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import '../models/post.dart';
import 'package:mime/mime.dart';

import '../utils/constants.dart';

class UploadPostController extends GetxController {
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

  uploadPost(File file) async {
    String res = '';
    try {
      String path = file.path;
      bool isVideo = false;
      if (lookupMimeType(path) == 'video/mp4') {
        isVideo = true;
      }

      String id = const Uuid().v1();
      String uid = firebaseAuth.currentUser!.uid;
      String postUrl = await _uploadFileToStorage('posts', path, id, isVideo);
      String thumbnail = '';
      if (isVideo) {
        thumbnail = await _uploadThumbnailToStorage('thumbnails', id, path);
      }
      Post post = Post(
          description: '',
          uid: uid,
          postId: id,
          datePublished: DateTime.now(),
          postUrl: postUrl,
          likes: [],
          isVideo: isVideo,
          thumbnail: thumbnail,
          isPublic: false,
          commentCount: 0);

      await firebaseFirestore.collection('posts').doc(id).set(
            post.toJson(),
          );
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    Get.snackbar('Upload Post', res);
  }
}
