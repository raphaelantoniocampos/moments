import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moments/screens/feed_screen.dart';
import 'package:moments/screens/search_screen.dart';

import '../screens/profile_screen.dart';

const appBarElevation = 0.0;

List<Widget> homeScreenItems = [
  const Center(
    child: SearchScreen(),
  ),
  const FeedScreen(),
  const Center(
    child: Text('Notifications'),
  ),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
