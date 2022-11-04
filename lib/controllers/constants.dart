import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'auth_controller.dart';

//FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firebaseFirestore = FirebaseFirestore.instance;

//CONTROLLER
var authController = AuthController.instance;

//PROFILE PIC
const initialProfilePic = 'https://firebasestorage.googleapis.com/v0/b/moments-a47d4.appspot.com/o/model%2FinitialProfilePic.jpg?alt=media&token=05c1a014-b453-4ba7-a1fb-fd2e4ade68db';