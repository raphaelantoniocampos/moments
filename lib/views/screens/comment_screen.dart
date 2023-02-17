import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moments/views/screens/user_list_screen.dart';
import 'package:moments/views/widgets/comment_card.dart';
import 'package:moments/views/widgets/like_button.dart';
import 'package:moments/views/widgets/profile_button.dart';

import 'package:moments/controllers/comment_controller.dart';
import '../../constants.dart';
import 'package:timeago/timeago.dart' as tago;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          "COMMENTS",
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Heuvetica Neue',
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
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
                                    if (snapshot.hasError ||
                                        !snapshot.hasData) {
                                      return const ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: primaryColor,
                                          backgroundImage:
                                              NetworkImage(initialProfilePic),
                                        ),
                                      );
                                    }
                                    final user = snapshot.data!.docs[0].data();
                                    return
                                      CommentCard(user: user, comment: comment);
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
