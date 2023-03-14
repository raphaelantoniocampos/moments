import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moments/views/widgets/like_button.dart';
import 'package:moments/views/widgets/profile_button.dart';
import 'package:moments/models/comment.dart';

import '../../constants.dart';
import '../../controllers/comment_controller.dart';
import '../screens/user_list_screen.dart';

class CommentCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final Comment comment;

  CommentCard({Key? key, required this.user, required this.comment})
      : super(key: key);

  final CommentController commentController = Get.put(
    CommentController(),
  );



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Stack(
            children: [
              ProfileButton(user: user),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.play_circle),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 330,
                height: 40,
                alignment: Alignment.centerLeft,
                child: Text(comment.audioUrl),
              ),
              Expanded(
                child: LikeButton(
                  comment: comment,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
