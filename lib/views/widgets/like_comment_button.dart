// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:get/get.dart';
// import '../../constants.dart';
// import '../../controllers/post_controller.dart';
// import '../../models/post.dart';
// import '../../models/user.dart';
// import '../../providers/user_provider.dart';
// import '../screens/user_list_screen.dart';
// import 'like_animation.dart';
//
// class LikeCommentButton extends StatefulWidget {
//   final Post post;
//
//   const LikeCommentButton({Key? key, required this.post}) : super(key: key);
//
//   @override
//   State<LikeCommentButton> createState() => _LikeCommentButtonState();
// }
//
// class _LikeCommentButtonState extends State<LikeCommentButton> {
//   final PostController postController = Get.put(PostController());
//
//   @override
//   Widget build(BuildContext context) {
//     final User? user = Provider.of<UserProvider>(context).getUser;
//     return InkWell(
//       onTap: () {
//         postController.likePost(widget.post.postId);
//         if (widget.post.likes.contains(user?.uid)) {
//           widget.post.likes.remove(user?.uid);
//         } else {
//           widget.post.likes.add(user?.uid);
//         }
//       },
//       onLongPress: () {
//         Get.to(
//           () => UserListScreen(
//               title: 'Comment likes', uidList: widget.post.likes),
//         );
//       },
//       child: Row(
//         children: [
//           widget.post.likes.contains(user?.uid)
//               ? const Icon(
//                   Icons.favorite_border,
//                   color: Colors.pinkAccent,
//                   size: 30,
//                 )
//               : const Icon(
//                   Icons.favorite_border,
//                   color: secondaryColor,
//                   size: 30,
//                 ),
//           const SizedBox(
//             width: 5,
//           ),
//           Text(
//             '${widget.post.likes.length}',
//             style: TextStyle(
//                 color: widget.post.likes.contains(user?.uid)
//                     ? Colors.pinkAccent
//                     : secondaryColor),
//           ),
//         ],
//       ),
//     );
//   }
// }
