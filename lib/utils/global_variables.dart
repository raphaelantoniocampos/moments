import 'package:flutter/material.dart';
import 'package:moments/screens/feed_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  Center(
    child: Text('Search'),
  ),
  FeedScreen(),
  Center(
    child: Text('Notifications'),
  ),
  Center(
    child: Text('Profile'),
  ),
];
