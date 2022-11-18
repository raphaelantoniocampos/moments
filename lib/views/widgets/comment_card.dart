import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moments/controllers/comment_controller.dart';
import 'package:get/get.dart';
import 'package:moments/main.dart';

import '../../constants.dart';


class CommentCard extends StatefulWidget {
  final snap;

  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  CommentController commentController = Get.put(CommentController());


  Future<DocumentSnapshot> getUser() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();

    return snap;
  }

  @override
  Widget build(BuildContext context) {
    // final User? user = Provider.of<UserProvider>(context).getUser;
    // return user == null
    //     ? const LoadingScreen()
    //     :
    return FutureBuilder<DocumentSnapshot>(
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
                                commentController.likeComment(
                                    widget.snap['commentId']);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    size: 20,
                                    color: widget.snap['likes']
                                            .contains(myUid)
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
