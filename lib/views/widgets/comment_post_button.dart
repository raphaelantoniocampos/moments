import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/post_controller.dart';
import '../../models/post.dart';
import '../screens/comment_screen.dart';

class CommentPostButton extends StatefulWidget {
  final Post post;

  const CommentPostButton({Key? key, required this.post}) : super(key: key);

  @override
  State<CommentPostButton> createState() => _CommentPostButtonState();
}

class _CommentPostButtonState extends State<CommentPostButton> {
  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return
      InkWell(
        onTap: () => Get.to(() =>
            CommentScreen(postId: widget.post.postId)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            children: [
              const Icon(
                Icons.mode_comment_outlined,
                color: Colors.black,
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                widget.post.commentCount.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1,
                  fontFamily: 'Helvetica Neue',
                ),
              ),
            ],
          ),
        ),
      );
  }
}
