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
var authController = AuthController.instance;

//INITIAL IMAGES
const initialProfilePic =
    'https://firebasestorage.googleapis.com/v0/b/moments-a47d4.appspot.com/o/model%2FinitialProfilePic.jpg?alt=media&token=05c1a014-b453-4ba7-a1fb-fd2e4ade68db';
const initialCoverPic =
    'https://firebasestorage.googleapis.com/v0/b/moments-a47d4.appspot.com/o/model%2FinitialCoverPic.jpg?alt=media&token=b0506430-ed74-49ce-91f5-00f94442ec82';

//THEME SETTINGS AND COLORS
const appBarElevation = 0.0;

const backgroundColor = Colors.white;
const searchColor = Color.fromRGBO(38, 38, 38, 1);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const likeColor = Colors.pinkAccent;
const primaryColor = Colors.blue;
// const primaryColor = Color.fromRGBO(80, 150, 255, 0.9019607843137255);
const secondaryColor = Colors.black;
const blackTransparent = Color.fromRGBO(18, 18, 18, 0.2);
const listColors = [Colors.greenAccent, Colors.orangeAccent, Colors.redAccent, Colors.blueAccent, Colors.yellow];

//HOME SCREEN ITENS
List<Widget> pages = [
  SearchScreen(),
  const FeedScreen(),
  const Center(
    child: Text('Messages'),
  ),
  ProfileScreen(
    uid: firebaseAuth.currentUser!.uid,
  ),
];

//PUBLIC AND HIDE POSTS
const int publicLimit = 1;
const int hideLimit = 5;
const int limitFriends = 150;
