import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moments/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../widgets/comment_card.dart';
import 'loading_screen.dart';

class CommentsScreen extends StatefulWidget {
  final snap;

  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return user == null
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: const Text('Comments'),
              centerTitle: false,
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.snap['postId'])
                  .collection('comments')
                  .orderBy('datePublished')
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return CommentCard(snap: snapshot.data!.docs[index].data());
                  },
                );
              },
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                height: kToolbarHeight,
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                      radius: 18,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: 'Comment',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: secondaryColor),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        String res = await FirestoreMethods().postComment(
                            user.uid,
                            widget.snap['postId'],
                            _commentController.text);
                        setState(() {
                          _commentController.text = '';
                        });
                      },
                      icon: const Icon(
                        Icons.send,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}