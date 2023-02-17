import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moments/constants.dart';
import '../../models/post.dart';
import '../screens/profile_screen.dart';
import 'image_widget.dart';

class ProfileButton extends StatelessWidget {
  final Map<String, dynamic> user;

  const ProfileButton({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final randomColor = listColors[Random().nextInt(listColors.length)];
    return Container(
      // width: 140,
      height: 42,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 0.5,
              offset: Offset(0.5, 0.5),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            InkWell(
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(1, 1),
                        blurRadius: 1)
                  ],
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      user['profilePic'],
                    ),
                  ),
                ),
              ),
              onTap: () {
                Get.to(
                  () => ImageWidget(
                    url: user['profilePic'],
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => Get.to(
                () => ProfileScreen(uid: user['uid']),
              ),
              child: Text(
                user['username'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Helvetica Neue',
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
