import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moments/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

import 'package:moments/models/user.dart';
import 'package:moments/models/comment.dart';
import '../../constants.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../screens/loading_screen.dart';


class CommentCard extends StatefulWidget {
  final snap;

  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  Future<DocumentSnapshot> getUser() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();

    return snap;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return user == null
        ? const LoadingScreen()
        : FutureBuilder<DocumentSnapshot>(
            future: getUser(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingCard();
              }
              if (snapshot.hasData && !snapshot.data!.exists) {
                return const LoadingCard();
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> snap =
                    snapshot.data!.data() as Map<String, dynamic>;
                return
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              //Profile pic
                              CircleAvatar(
                                backgroundImage:

                                    // NetworkImage(userSnap['profilePic']),

                                    NetworkImage(snap['profilePìc']),
                              ),

                              //Username
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  snap['username'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
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
                                    user.uid,
                                    widget.snap['commentId'],
                                    widget.snap['likes']);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    size: 20,
                                    color: widget.snap['likes']
                                            .contains(user.uid)
                                        ? Colors.pinkAccent
                                        : secondaryColor,
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
              return const LoadingCard();
            });
  }
}

class LoadingCard extends StatelessWidget {
  const LoadingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
