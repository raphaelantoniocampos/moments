import 'package:flutter/material.dart';
import 'package:moments/views/widgets/profile_button.dart';

import '../../models/comment.dart';
import 'package:timeago/timeago.dart' as tago;
import 'like_button.dart';


class CommentCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final Comment comment;
  const CommentCard({Key? key, required this.user, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          ProfileButton(user: user),
          const SizedBox(
            height: 10,
          ),
          Text(
            comment.text,
            style: const TextStyle(
              fontFamily: 'Heuvetica Neue',
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 16,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 60,
                child: LikeButton(
                  comment: comment,
                ),
              ),
              Text(
                tago.format(
                  comment.datePublished
                      .toDate(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
