import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moments/views/widgets/comment_card.dart';

import 'package:moments/controllers/comment_controller.dart';
import '../../constants.dart';

class CommentScreen extends StatefulWidget {
  final String postId;

  const CommentScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  bool _isLoading = false;

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
      body: _isLoading
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
                                    return CommentCard(
                                        user: user, comment: comment);
                                  });
                            });
                      }),
                    ),
                    const Divider(),
                    Row(
                      children: [
                        GestureDetector(
                          onLongPress: () {
                            commentController.startRecording();
                          },
                          onLongPressUp: () {
                            commentController.stopRecording();
                            commentController.postComment(widget.postId);
                          },
                          child: Icon(
                            Icons.play_circle,
                            size: 40,
                          ),
                        ),
                        // Text(_timerText)
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
