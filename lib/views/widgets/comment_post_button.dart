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
        child: Row(
          children: [
            const Icon(
              Icons.mode_comment_outlined,
              color: Colors.black,
              size: 27,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              widget.post.commentCount.toString(),
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
  }
}
