import 'package:flutter/material.dart';
import 'package:moments/screens/feed_screen.dart';
import 'package:moments/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  Center(
    child: SearchScreen(),
  ),
  FeedScreen(),
  Center(
    child: Text('Notifications'),
  ),
  Center(
    child: Text('Profile'),
  ),
];
