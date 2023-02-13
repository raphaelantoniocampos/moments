import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moments/views/screens/profile_screen.dart';
import 'package:moments/views/widgets/image_widget.dart';
import 'package:moments/views/widgets/like_post_button.dart';

import '../../constants.dart';
import '../../models/post.dart';
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
                backgroundColor: Colors.black,
                body: Stack(
                  children: [
                    widget.post.isVideo
                        ? VideoWidget(post: widget.post)
                        : ImageWidget(url: widget.post.downloadUrl),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(uid: widget.post.uid),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage: NetworkImage(
                                      user['profilePic'],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      user['username'],
                                      style: const TextStyle(
                                          color: backgroundColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            LikePostButton(post: widget.post)
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        )
                      ],
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
