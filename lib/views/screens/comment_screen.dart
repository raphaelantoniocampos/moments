import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moments/views/screens/user_list_screen.dart';
import 'package:moments/views/widgets/profile_button.dart';

import 'package:moments/controllers/comment_controller.dart';
import '../../constants.dart';

class CommentScreen extends StatefulWidget {
  final String postId;

  const CommentScreen({Key? key, required this.postId}) : super(key: key);

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
        title: const Text("Comments"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SizedBox(
                width: size.width,
                height: size.height - 80,
                child: Column(
                  children: [
                    Expanded(
                      child: Obx(() {
                        final comments = commentController.comments;
                        return ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
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
                                    if (snapshot.hasError) {
                                      return const ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: primaryColor,
                                          backgroundImage:
                                              NetworkImage(initialProfilePic),
                                        ),
                                      );
                                    }
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
                                        ConnectionState.done) {
                                      final user =
                                          snapshot.data!.docs[0].data();
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        child:
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ProfileButton(user: user),
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
                                                      commentController
                                                          .updateCommentLikes(
                                                              comment);
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
                                                              ? likeColor
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
