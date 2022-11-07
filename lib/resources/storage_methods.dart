import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //add image to firebase storage
  Future<String> uploadFileToStorage(String childName, Uint8List file) async {
    String id = const Uuid().v1();
    Reference ref =
        firebaseStorage.ref().child(childName).child(firebaseAuth.currentUser!.uid).child(id);


    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
