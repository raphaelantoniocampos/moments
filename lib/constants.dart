import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:moments/views/screens/feed_screen.dart';
import 'package:moments/views/screens/profile_screen.dart';
import 'package:moments/views/screens/search_screen.dart';

import 'controllers/auth_controller.dart';

//FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firebaseFirestore = FirebaseFirestore.instance;

//CONTROLLER
var authController = AuthController.instance;

//INITIAL IMAGES
const initialProfilePic = 'https://firebasestorage.googleapis.com/v0/b/moments-a47d4.appspot.com/o/model%2FinitialProfilePic.jpg?alt=media&token=05c1a014-b453-4ba7-a1fb-fd2e4ade68db';
const initialCoverPic = 'https://www.macmillandictionary.com/us/external/slideshow/full/Grey_full.png';

//THEME SETTINGS AND COLORS
const appBarElevation = 0.0;

const backgroundColor = Colors.white;
const searchColor = Color.fromRGBO(38, 38, 38, 1);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
// const primaryColor = Color.fromRGBO(196, 138, 0, 1.0);
// const primaryColor = Color.fromRGBO(255, 56, 56, 0.9019607843137255);
const primaryColor = Color.fromRGBO(80, 150, 255, 0.9019607843137255);
// const primaryColor = Colors.black;
const secondaryColor = Colors.grey;
const blackTransparent = Color.fromRGBO(18, 18, 18, 0.2);


//HOME SCREEN ITENS
List<Widget> pages = [
  SearchScreen(),
  FeedScreen(),
  Center(
    child: Text('Messages'),
  ),
  ProfileScreen(
    uid: firebaseAuth.currentUser!.uid,
  ),
];

//PUBLIC AND HIDE POSTS
int publicLimit = 1;
int hideLimit = 5;




