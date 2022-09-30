import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moments/resources/firestore_methods.dart';
import 'package:moments/utils/colors.dart';

import '../models/user.dart' as model;

class CommentCard extends StatefulWidget {
  final snap;

  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  // late final DocumentSnapshot userSnap;

  // @override
  // void initState() {
  //   userSnap = getUser() as DocumentSnapshot<Object?>;
  //   super.initState();
  // }

  // Future<DocumentSnapshot<Object?>> getUser() async {
  //   return await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(widget.snap['uid'])
  //       .get();
  //
  //   // final user = model.User.fromSnap(snap);
  //   // print('print user snap ${snap.data()}');
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  //Profile pic
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/moments-a47d4.appspot.com/o/posts%2Fh4vKe4Je6NecCkP1K9ARG9clHVM2%2F815e4400-40cf-11ed-8b2c-3d3ecfb6ff6b?alt=media&token=37238dd1-0ab3-4b1c-a5d8-30a1e296e552'),
                  ),

                  //Username
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      'username',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              //Datetime
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(DateFormat.yMd()
                    .add_Hm()
                    .format(widget.snap['datePublished'].toDate())),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 330,
                height: 40,
                alignment: Alignment.centerLeft,
                child: Text(widget.snap['text']),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FirestoreMethods().likeComment(
                        widget.snap['postId'],
                        widget.snap['uid'],
                        widget.snap['commentId'],
                        widget.snap['likes']);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: widget.snap['likes'].contains(widget.snap['uid']) ? Colors.pinkAccent : secondaryColor,
                      ),
                      Text(' ${widget.snap['likes'].length}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
