import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../controllers/post_controller.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../screens/user_list_screen.dart';
import 'like_animation.dart';

class LikePostButton extends StatefulWidget {
  final Post post;

  const LikePostButton({Key? key, required this.post}) : super(key: key);

  @override
  State<LikePostButton> createState() => _LikePostButtonState();
}

class _LikePostButtonState extends State<LikePostButton> {
  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return LikeAnimation(
      isAnimating: widget.post.likes.contains(user?.uid),
      smallLike: true,
      child: InkWell(
        onTap: () {
          postController.likePost(widget.post.postId);
          if (widget.post.likes.contains(user?.uid)) {
            setState(() {
              widget.post.likes.remove(user?.uid);
            });
          } else {
            setState(() {
              widget.post.likes.add(user?.uid);
            });
          }
        },
        onLongPress: () {
          Get.to(
            () =>
                UserListScreen(title: 'Post likes', uidList: widget.post.likes),
          );
        },
        child: Row(
          children: [
            Icon(
              Icons.favorite_border,
              color: widget.post.likes.contains(user?.uid)
                  ? Colors.pinkAccent
                  : Colors.black,
              size: 30,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              '${widget.post.likes.length}',
              style: TextStyle(
                  color: widget.post.likes.contains(user?.uid)
                      ? Colors.pinkAccent
                      : Colors.black,
              fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
