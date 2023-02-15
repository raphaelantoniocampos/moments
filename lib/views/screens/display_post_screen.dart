import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moments/views/screens/profile_screen.dart';
import 'package:moments/views/widgets/image_widget.dart';
import 'package:moments/views/widgets/like_post_button.dart';
import 'package:moments/views/widgets/profile_button.dart';

import '../../constants.dart';
import '../../models/post.dart';
import '../widgets/comment_post_button.dart';
import '../widgets/video_widget.dart';
import 'loading_screen.dart';

class DisplayPostScreen extends StatefulWidget {
  final Post post;

  const DisplayPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<DisplayPostScreen> createState() => _DisplayPostScreenState();
}

class _DisplayPostScreenState extends State<DisplayPostScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebaseFirestore
            .collection('users')
            .where('uid', isEqualTo: widget.post.uid)
            .get(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const LoadingScreen();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var docs = snapshot.data!.docs;
            var user = docs[0].data();
            return Scaffold(
                backgroundColor: backgroundColor,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      // alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        widget.post.isVideo
                            ? VideoWidget(post: widget.post)
                            : ImageWidget(url: widget.post.downloadUrl),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child:
                                  ProfileButton(post: widget.post, user: user),
                            ),
                            const SizedBox(
                              height: 600,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: LikePostButton(post: widget.post),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: CommentPostButton(post: widget.post),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
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
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                )
                // VideoPlayerItem(),
                );
          }
          return const LoadingScreen();
        });
  }
}
