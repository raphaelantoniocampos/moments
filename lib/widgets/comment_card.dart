import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moments/resources/auth_methods.dart';

import '../models/user.dart' as model;

class CommentCard extends StatefulWidget {
  final snap;

  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {

  // void getUser() async {
  //   DocumentSnapshot snap = (await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(widget.snap['uid'])
  //       .get());
  //
  //   user = model.User.fromSnap(snap);
  //   print(snap);
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
                    backgroundImage: NetworkImage(''),
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
          Container(
            // color: Colors.pink,
            height: 40,
            alignment: Alignment.centerLeft,
            child: Text(widget.snap['text']),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.favorite_border,
                  size: 15,
                ),
              ),
              Text(' 15'),
              const SizedBox(
                width: 15,
              ),
              const Icon(
                Icons.mode_comment_outlined,
                size: 15,
              ),
              Text(' 20'),
            ],
          ),
        ],
      ),
    );
  }
}
