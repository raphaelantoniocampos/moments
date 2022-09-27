import 'package:flutter/material.dart';
import 'package:moments/utils/colors.dart';

import '../widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Comments'),
        centerTitle: false,
      ),
      body: CommentCard(),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/moments-a47d4.appspot.com/o/posts%2Fh4vKe4Je6NecCkP1K9ARG9clHVM2%2F4ee20160-3d91-11ed-9c6d-75b9c6f65e65?alt=media&token=4ef24f00-44d2-4f65-aee7-a2ca72bde860'),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Comment',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: secondaryColor),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
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
