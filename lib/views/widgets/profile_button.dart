import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/post.dart';
import '../screens/profile_screen.dart';
import 'image_widget.dart';

class ProfileButton extends StatelessWidget {
  final Map<String, dynamic> user;

  const ProfileButton({Key? key, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => ProfileScreen(uid: user['uid'])),
      child: Row(
        children: [
          InkWell(
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                user['profilePic'],
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
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(
              user['username'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
