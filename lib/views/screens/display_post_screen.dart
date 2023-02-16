import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/post.dart';
import '../widgets/comment_post_button.dart';
import '../widgets/image_widget.dart';
import '../widgets/like_post_button.dart';
import '../widgets/profile_button.dart';
import '../widgets/video_widget.dart';

class DisplayPostScreen extends StatefulWidget {
  final Post post;

  const DisplayPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  _DisplayPostScreenState createState() => _DisplayPostScreenState();
}

class _DisplayPostScreenState extends State<DisplayPostScreen> {
  late Future<QuerySnapshot<Map<String, dynamic>>> _future;
  bool showDetails = true;

  @override
  void initState() {
    super.initState();
    _future = firebaseFirestore
        .collection('users')
        .where('uid', isEqualTo: widget.post.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            final user = docs[0].data();
            return GestureDetector(
              onTap: (){
                setState(() {
                  showDetails = !showDetails;
                });
              },
              child: Stack(
                children: [
                  widget.post.isVideo
                      ? VideoWidget(post: widget.post)
                      : ImageWidget(url: widget.post.downloadUrl),
                  AnimatedOpacity(
                    opacity: showDetails ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: ProfileButton(user: user),
                        ),
                        const SizedBox(height: 600),
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.post.description,
                              style: const TextStyle(
                                color: backgroundColor,
                                shadows: [
                                  Shadow(
                                    color: Colors.grey,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              LikePostButton(post: widget.post),
                              const SizedBox(width: 10),
                              CommentPostButton(post: widget.post),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
