import 'package:flutter/material.dart';
import 'package:moments/constants.dart';
import 'package:moments/controllers/comment_controller.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import '../../controllers/post_controller.dart';
import '../../models/post.dart';
import '../../models/comment.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../screens/user_list_screen.dart';
import 'like_animation.dart';

class LikeButton extends StatefulWidget {
  final Comment? comment;
  final Post? post;

  const LikeButton({Key? key, this.comment, this.post}) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    final bool isLiked =
    widget.post != null ? widget.post!.likes.contains(user?.uid) : widget.comment!.likes.contains(user?.uid);
    return LikeAnimation(
      isAnimating: isLiked,
      smallLike: true,
      child: Tooltip(
        message: isLiked ? 'Unlike ${widget.post != null ? 'post' : 'comment'}' : 'Like ${widget.post != null ? 'post' : 'comment'}',
        child: InkResponse(
          onTap: () {
            if (widget.post != null) {
              final PostController postController = Get.put(PostController());
              postController.likePost(widget.post!.postId);
              if (isLiked) {
                setState(() {
                  widget.post!.likes.remove(user?.uid);
                });
              } else {
                setState(() {
                  widget.post!.likes.add(user?.uid);
                });
              }
            } else {
              final CommentController commentController = Get.put(CommentController());
              commentController.likeComment(widget.comment!.id);
            }
          },
          onLongPress: () {
            Get.to(
                  () => UserListScreen(
                title: '${widget.post != null ? 'Post' : 'Comment'} likes',
                uidList: widget.post != null ? widget.post!.likes : widget.comment!.likes,
              ),
            );
          },
          child: Row(
            children: [
              Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? likeColor : null,
                size: 30,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '${widget.post != null ? widget.post!.likes.length : widget.comment!.likes.length}',
                style: TextStyle(
                  color: isLiked ? likeColor : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
