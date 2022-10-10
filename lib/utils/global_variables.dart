import 'package:flutter/material.dart';
import 'package:moments/screens/feed_screen.dart';
import 'package:moments/screens/search_screen.dart';

import '../screens/profile_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const Center(
    child: SearchScreen(),
  ),
  const FeedScreen(),
  const Center(
    child: Text('Notifications'),
  ),
  const ProfileScreen(),
];
