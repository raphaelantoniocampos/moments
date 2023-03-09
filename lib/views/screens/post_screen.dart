import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moments/views/widgets/like_button.dart';

import '../../constants.dart';
import '../../models/post.dart';
import '../widgets/comment_post_button.dart';
import '../widgets/image_widget.dart';
import '../widgets/profile_button.dart';
import '../widgets/video_widget.dart';

class PostScreen extends StatefulWidget {
  final Post post;

  const PostScreen({Key? key, required this.post}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Future<QuerySnapshot<Map<String, dynamic>>> _userFuture;
  bool showDetails = true;

  @override
  void initState() {
    super.initState();
    _userFuture = firebaseFirestore
        .collection('users')
        .where('uid', isEqualTo: widget.post.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }
          final user = snapshot.data!.docs[0].data();
          return GestureDetector(
            onTap: () {
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
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.2),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.4),
                        ],
                        stops: const [
                          0.0,
                          0.1,
                          0.2,
                          0.8,
                          0.9,
                          1.0,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: ProfileButton(user: user),
                        ),
                        const SizedBox(
                          height: 600,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
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
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LikeButton(post: widget.post),
                                const SizedBox(width: 16),
                                CommentPostButton(post: widget.post),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
