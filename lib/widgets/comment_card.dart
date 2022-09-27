import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({Key? key}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/moments-a47d4.appspot.com/o/posts%2Fh4vKe4Je6NecCkP1K9ARG9clHVM2%2F16605d30-3e60-11ed-879a-5599bceda250?alt=media&token=d9039393-db3e-4c57-8230-be14e942438f'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                Text(
                  'username',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('22/09/2022 - 13:54'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
