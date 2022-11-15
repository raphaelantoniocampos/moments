import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:moments/views/widgets/like_post_button.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../controllers/post_controller.dart';
import '../../controllers/profile_pic_controller.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../screens/comment_screen.dart';
import '../screens/delete_post_screen.dart';
import '../screens/display_post_screen.dart';
import '../screens/loading_screen.dart';
import '../screens/profile_screen.dart';
import 'like_animation.dart';
import 'loading_post.dart';

class PostCard extends StatefulWidget {
  // final Map<String, dynamic> snap;
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final PostController postController = Get.put(PostController());
  bool isLikeAnimating = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    isLikeAnimating = false;
    return user == null
        ? const LoadingScreen()
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
                decoration: const BoxDecoration(
                  color: backgroundColor,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    //Header section
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 4, horizontal: 8)
                              .copyWith(right: 0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfileScreen(uid: widget.post.uid),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(
                                    user['profilePic'],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      user['username'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
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
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: const Text(
                                                      'Add description'),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  ProfilePicController()
                                                      .changeProfilePic(
                                                          widget.post);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: const Text(
                                                      'Use as profile picture'),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  postController.makePublic(
                                                      widget.post.postId);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: const Text(
                                                      'Make/unmake public'),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  Navigator.of(context)
                                                      .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DeletePostScreen(
                                                            postId: widget
                                                                .post.postId,
                                                          ),
                                                        ),
                                                      )
                                                      .then((value) =>
                                                          Navigator.of(context)
                                                              .pop());
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: const Text('Delete'),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
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
                    ),

                    //Post section
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DisplayPostScreen(
                              post: widget.post,
                            ),
                          ),
                        );
                      },
                      onDoubleTap: () async {
                        postController.likePost(widget.post.postId);
                        setState(() {
                          isLikeAnimating = true;
                        });
                      },
                      child: Stack(alignment: Alignment.center, children: [
                        Container(
                          decoration: widget.post.isPublic
                              ? const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        width: 2, color: Colors.greenAccent),
                                    left: BorderSide(
                                        width: 2, color: Colors.greenAccent),
                                    right: BorderSide(
                                        width: 2, color: Colors.greenAccent),
                                    bottom: BorderSide(
                                        width: 2, color: Colors.greenAccent),
                                  ),
                                )
                              : null,
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: double.infinity,
                          child: widget.post.isVideo
                              ? Image.network(widget.post.thumbnail,
                                  fit: BoxFit.cover)
                              : Image.network(
                                  widget.post.downloadUrl,
                                  fit: BoxFit.cover,
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
                          LikePostButton(post: widget.post),
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
                          //                 color: Colors.pinkAccent,
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
                          //                       ? Colors.pinkAccent
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
                                fontSize: 10,
                                color: Colors.black,
                                fontStyle: FontStyle.italic),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CommentScreen(
                                    postId: widget.post.postId,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.mode_comment_outlined,
                                  color: secondaryColor,
                                  size: 30,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.post.commentCount.toString(),
                                  style: const TextStyle(color: secondaryColor),
                                ),
                              ],
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
