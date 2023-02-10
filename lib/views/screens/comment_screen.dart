import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moments/views/screens/profile_screen.dart';
import 'package:moments/views/screens/user_list_screen.dart';
import 'package:timeago/timeago.dart' as tago;

import 'package:moments/controllers/comment_controller.dart';
import '../../constants.dart';
import 'loading_screen.dart';

class CommentScreen extends StatefulWidget {
  final String postId;

  CommentScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool isLoading = false;

  CommentController commentController = Get.put(
    CommentController(),
  );

  @override
  void initState() {
    commentController.updatePostId(widget.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: isLoading
          ? const LoadingScreen()
          : SingleChildScrollView(
              child: SizedBox(
                width: size.width,
                height: size.height - 70,
                child: Column(
                  children: [
                    Expanded(
                      child: Obx(() {
                        return ListView.builder(
                            itemCount: commentController.comments.length,
                            itemBuilder: (context, index) {
                              final comment = commentController.comments[index];
                              return FutureBuilder(
                                  future: firebaseFirestore
                                      .collection('users')
                                      .where('uid', isEqualTo: comment.uid)
                                      .get(),
                                  builder: (context,
                                      AsyncSnapshot<
                                              QuerySnapshot<
                                                  Map<String, dynamic>>>
                                          snapshot) {
                                    if (!snapshot.hasData) {
                                      return const ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: primaryColor,
                                          backgroundImage:
                                              NetworkImage(initialProfilePic),
                                        ),
                                      );
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: primaryColor,
                                          backgroundImage:
                                              NetworkImage(initialProfilePic),
                                        ),
                                      );
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      var docs = snapshot.data!.docs;
                                      var user = docs[0].data();
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () =>
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfileScreen(
                                                              uid: user['uid']),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      //Profile pic
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(user[
                                                                'profilePic']),
                                                      ),

                                                      //Username
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 8),
                                                        child: Text(
                                                          user['username'],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                //Datetime
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Text(tago.format(
                                                      comment.datePublished
                                                          .toDate())),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 330,
                                                  height: 40,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(comment.text),
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      commentController
                                                          .likeComment(
                                                              comment.id);
                                                    },
                                                    onLongPress: () {
                                                      commentController.updateCommentLikes(comment);
                                                      Get.to(
                                                        () => UserListScreen(
                                                            title:
                                                                'Comment likes',
                                                            uidList:
                                                                commentController
                                                                    .commentUidList),
                                                      );
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.favorite_border,
                                                          size: 20,
                                                          color: comment.likes
                                                                  .contains(
                                                                      authController
                                                                          .user
                                                                          .uid)
                                                              ? Colors
                                                                  .pinkAccent
                                                              : secondaryColor,
                                                        ),
                                                        Text(
                                                            ' ${comment.likes.length}'),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return const ListTile();
                                  });
                            });
                      }),
                    ),
                    const Divider(),
                    ListTile(
                      title: TextFormField(
                        controller: _commentController,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        decoration: const InputDecoration(
                          labelText: "Comment",
                          labelStyle: TextStyle(
                              fontSize: 20,
                              color: secondaryColor,
                              fontWeight: FontWeight.w700),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          commentController
                              .postComment(_commentController.text);
                          _commentController.text = '';
                        },
                        icon: const Icon(
                          Icons.send,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// class CommentsScreen extends StatefulWidget {
//   final snap;
//
//   const CommentsScreen({Key? key, required this.snap}) : super(key: key);
//
//   @override
//   State<CommentsScreen> createState() => _CommentsScreenState();
// }
//
// class _CommentsScreenState extends State<CommentsScreen> {
//   final _commentController = TextEditingController();
//
//   @override
//   void dispose() {
//     super.dispose();
//     _commentController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final User? user = Provider.of<UserProvider>(context).getUser;
//
//     return user == null
//         ? const LoadingScreen()
//         : Scaffold(
//             appBar: AppBar(
//               backgroundColor: primaryColor,
//               title: const Text('Comments'),
//               centerTitle: false,
//             ),
//             body: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('posts')
//                   .doc(widget.snap['postId'])
//                   .collection('comments')
//                   .orderBy('datePublished')
//                   .snapshots(),
//               builder: (context,
//                   AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const LoadingScreen();
//                 }
//                 return ListView.builder(
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     return CommentCard(snap: snapshot.data!.docs[index].data());
//                   },
//                 );
//               },
//             ),
//             bottomNavigationBar: SafeArea(
//               child: Container(
//                 height: kToolbarHeight,
//                 margin: EdgeInsets.only(
//                     bottom: MediaQuery.of(context).viewInsets.bottom),
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundImage: NetworkImage(user.profilePic),
//                       radius: 18,
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         child: TextField(
//                           controller: _commentController,
//                           decoration: const InputDecoration(
//                             hintText: 'Comment',
//                             border: InputBorder.none,
//                             hintStyle: TextStyle(color: secondaryColor),
//                           ),
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () async {
//                         String res = await FirestoreMethods().postComment(
//                             user.uid,
//                             widget.snap['postId'],
//                             _commentController.text);
//                         setState(() {
//                           _commentController.text = '';
//                         });
//                       },
//                       icon: const Icon(
//                         Icons.send,
//                         color: secondaryColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//   }
// }
