import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:moments/views/widgets/comment_post_button.dart';
import 'package:moments/views/widgets/like_button.dart';
import 'package:moments/views/widgets/profile_button.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../controllers/post_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../screens/delete_post_screen.dart';
import '../screens/post_screen.dart';
import 'like_animation.dart';
import 'loading_post.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final PostController postController = Get.put(PostController());
  final UserController profileController = Get.put(UserController());

  bool isLikeAnimating = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    isLikeAnimating = false;
    return user == null
        ? const Center(child: CircularProgressIndicator())
        : FutureBuilder(
            future: firebaseFirestore
                .collection('users')
                .where('uid', isEqualTo: widget.post.uid)
                .get(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingPost();
              }
              var docs = snapshot.data!.docs;
              var user = docs[0].data();
              return Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    //Header section
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProfileButton(user: user),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                    barrierColor: blackTransparent,
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: ListView(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shrinkWrap: true,
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child:
                                                  const Text('Add description'),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              profileController
                                                  .changeProfilePic(
                                                      widget.post);
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: const Text(
                                                  'Use as profile picture'),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              profileController
                                                  .changeCoverPic(widget.post);
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: const Text(
                                                  'Use as cover picture'),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              postController.makePublic(
                                                  widget.post.postId);
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: const Text(
                                                  'Make/unmake public'),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              Get.to(() => DeletePostScreen(
                                                  postId: widget.post
                                                      .postId))?.then((value) =>
                                                  Navigator.of(context).pop());
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: const Text('Delete'),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: const Text('Report'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.more_vert)),
                          ],
                        ),
                        //Description
                        SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              widget.post.description,
                              style: const TextStyle(color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),

                    //Post section
                    GestureDetector(
                      onTap: () =>
                          Get.to(() => PostScreen(post: widget.post)),
                      onDoubleTap: () async {
                        // postController.likePost(widget.post.postId);
                        // setState(() {
                        //   isLikeAnimating = true;
                        // });
                      },
                      child: Stack(alignment: Alignment.center, children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 2,
                              color: widget.post.isPublic ? Colors.greenAccent : Colors.blue,
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.60,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: widget.post.isVideo
                                ? Image.network(widget.post.thumbnail, fit: BoxFit.cover)
                                : Image.network(
                              widget.post.downloadUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.play_arrow,
                          color: widget.post.isVideo
                              ? Colors.white
                              : Colors.transparent,
                          size: 70,
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 150),
                          opacity: isLikeAnimating ? 1 : 0,
                          child: LikeAnimation(
                            isAnimating: isLikeAnimating,
                            duration: const Duration(milliseconds: 100),
                            onEnd: () {
                              setState(() {
                                isLikeAnimating = false;
                              });
                            },
                            child: const Icon(
                              Icons.favorite,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                    ),

                    //Comment/like section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: LikeButton(post: widget.post),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: CommentPostButton(post: widget.post),
                              ),
                            ],
                          ),
                          // LikeAnimation(
                          //   isAnimating: widget.post.likes.contains(user.uid),
                          //   smallLike: true,
                          //   child: InkWell(
                          //     onTap: () => postController.likePost(widget.post.postId),
                          //     child: Row(
                          //       children: [
                          //         widget.post.likes.contains(user.uid)
                          //             ? const Icon(
                          //                 Icons.favorite_border,
                          //                 color: likeColor,
                          //                 size: 30,
                          //               )
                          //             : const Icon(
                          //                 Icons.favorite_border,
                          //                 color: secondaryColor,
                          //                 size: 30,
                          //               ),
                          //         const SizedBox(
                          //           width: 5,
                          //         ),
                          //         Text(
                          //           '${widget.post.likes.length}',
                          //           style: TextStyle(
                          //               color:
                          //                   widget.post.likes.contains(user.uid)
                          //                       ? likeColor
                          //                       : secondaryColor),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          //Datetime
                          Text(
                            DateFormat.yMMMMd()
                                .add_Hm()
                                .format(widget.post.datePublished.toDate()),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
