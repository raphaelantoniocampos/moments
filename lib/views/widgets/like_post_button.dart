import 'package:flutter/material.dart';
import 'package:moments/constants.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
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
    final bool isLiked = widget.post.likes.contains(user?.uid);
    return LikeAnimation(
      isAnimating: isLiked,
      smallLike: true,
      child: Tooltip(
        message: isLiked ? 'Unlike post' : 'Like post',
        child: InkResponse(
          onTap: () {
            postController.likePost(widget.post.postId);
            if (isLiked) {
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
                  () => UserListScreen(
                  title: 'Post likes', uidList: widget.post.likes),
            );
          },
          splashColor: Colors.white,
          highlightColor: Colors.white,
          radius: 30,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: isLiked ? likeColor : Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? likeColor : Colors.black,
                  size: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '${widget.post.likes.length}',
                  style: TextStyle(
                    color: isLiked ? likeColor : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1,
                    fontFamily: 'Helvetica Neue',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
