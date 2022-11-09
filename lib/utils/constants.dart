import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../screens/feed_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

//FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firebaseFirestore = FirebaseFirestore.instance;

//CONTROLLER
var authController = AuthController.instance;

//PROFILE PIC
const initialProfilePic = 'https://firebasestorage.googleapis.com/v0/b/moments-a47d4.appspot.com/o/model%2FinitialProfilePic.jpg?alt=media&token=05c1a014-b453-4ba7-a1fb-fd2e4ade68db';

//THEME SETTINGS AND COLORS
const appBarElevation = 0.0;

const backgroundColor = Colors.white;
const searchColor = Color.fromRGBO(38, 38, 38, 1);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
// const primaryColor = Color.fromRGBO(196, 138, 0, 1.0);
const primaryColor = Color.fromRGBO(255, 56, 56, 0.9019607843137255);
const secondaryColor = Colors.grey;
const blackTransparent = Color.fromRGBO(18, 18, 18, 0.2);

//HOME SCREEN ITENS
List<Widget> pages = [
  const Center(
    child: SearchScreen(),
  ),
  FeedScreen(),
  const Center(
    child: Text('Notifications'),
  ),
  ProfileScreen(
    uid: firebaseAuth.currentUser!.uid,
  ),
];




