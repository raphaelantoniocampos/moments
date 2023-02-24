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

//NEO-BRUTALIST

const backgroundColor = Color(0xFFF2F2F2); // branco sujo
const primaryColor = Color(0xFF333333); // Preto
const secondaryColor = Color(0xFFF5AEBD); // rosa pastel
const buttonColor = Color(0xFFF5E1A4); // amarelo suave
const appBarElevation = 0.0; // Sem elevação

ThemeData neoBrutalistTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: backgroundColor,
  primaryColor: primaryColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: backgroundColor,
    elevation: appBarElevation,
    foregroundColor: primaryColor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(buttonColor),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: primaryColor,
      fontFamily: 'Heuvetica Neue',
    ),
    displayMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: primaryColor,
      fontFamily: 'Heuvetica Neue',
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      color: primaryColor,
      fontFamily: 'Heuvetica Neue',
    ),
    bodyLarge: TextStyle(
      fontSize: 14,
      color: primaryColor,
      fontFamily: 'Heuvetica Neue',
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: backgroundColor,
      fontFamily: 'Heuvetica Neue',
    ),
  ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondaryColor).copyWith(secondary: secondaryColor),
);

// fontFamily: 'Heuvetica Neue',
// fontWeight: FontWeight.w700

// const appBarElevation = 0.0;

// const backgroundColor = Colors.white;
const searchColor = Color.fromRGBO(38, 38, 38, 1);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const likeColor = Colors.pinkAccent;
// const blackColor = Color(0xFF212121);
// const primaryColor = Color(0xFF2196F3); // Azul
// const primaryColor = Color.fromRGBO(80, 150, 255, 0.9019607843137255);
// const secondaryColor = Colors.black;
const blackTransparent = Color.fromRGBO(18, 18, 18, 0.2);
const listColors = [
  Colors.white,
  // Color(0xFF212121), // Preto
  // Color(0xFFE0E0E0), // Cinza Claro
  // Color(0xFF9E9E9E), // Cinza Escuro
  // Color(0xFFFF9800), // Laranja
  // Color(0xffffcc01), // Amarelo
  // Color(0xFF2196F3), // Azul
  // Color(0xFF4CAF50), // Verde
];
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

