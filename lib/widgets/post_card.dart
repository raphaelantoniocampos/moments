import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:moments/resources/firestore_methods.dart';
import 'package:moments/screens/comments_screen.dart';
import 'package:moments/screens/loading_screen.dart';
import 'package:moments/widgets/like_animation.dart';
import 'package:flutter/material.dart';
import 'package:moments/utils/colors.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../screens/delete_post_screen.dart';
import '../screens/profile_screen.dart';
import '../utils/global_variables.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .get();

    commentLen = snap.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return user == null
        ? const LoadingScreen()
        : StreamBuilder(
            initialData: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.snap['postId'])
                .collection('comments')
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<Future<QuerySnapshot<Map<String, dynamic>>>>
                    snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              }
              if (snapshot.connectionState == ConnectionState.done) {
                print(snapshot);
              }
              return Container(
                decoration: BoxDecoration(
                  color: mobileBackgroundColor,
                  border: Border.all(
                    color: width > webScreenSize
                        ? secondaryColor
                        : mobileBackgroundColor,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    //Header section
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 4, horizontal: 8)
                              .copyWith(right: 0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfileScreen(uid: widget.snap['uid']),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(
                                    widget.snap['profImage'],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      widget.snap['username'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                        barrierColor: blackTransparent,
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: ListView(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            shrinkWrap: true,
                                            children: [
                                              InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: const Text(
                                                      'Add description'),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: const Text(
                                                      'Use as profile picture'),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  Navigator.of(context)
                                                      .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DeletePostScreen(
                                                            postId: widget
                                                                .snap['postId'],
                                                          ),
                                                        ),
                                                      )
                                                      .then((value) =>
                                                          Navigator.of(context)
                                                              .pop());
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: const Text('Delete'),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: const Text('Report'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.more_vert)),
                              ],
                            ),
                          ),
                          //Description
                          SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                widget.snap['description'],
                                style: const TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Post section
                    GestureDetector(
                      onDoubleTap: () async {
                        FirestoreMethods().likePost(widget.snap['postId'],
                            user.uid, widget.snap['likes']);
                        setState(() {
                          isLikeAnimating = true;
                        });
                      },
                      child: Stack(alignment: Alignment.center, children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: double.infinity,
                          child: Image.network(
                            widget.snap['postUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 150),
                          opacity: isLikeAnimating ? 1 : 0,
                          child: LikeAnimation(
                            isAnimating: isLikeAnimating,
                            duration: const Duration(milliseconds: 100),
                            onEnd: () {
                              setState(() {
                                isLikeAnimating = false;
                              });
                            },
                            child: const Icon(
                              Icons.favorite,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                    ),

                    //Comment/like section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LikeAnimation(
                            isAnimating:
                                widget.snap['likes'].contains(user.uid),
                            smallLike: true,
                            child: InkWell(
                              onTap: () async {
                                FirestoreMethods().likePost(
                                    widget.snap['postId'],
                                    user.uid,
                                    widget.snap['likes']);
                              },
                              child: Row(
                                children: [
                                  widget.snap['likes'].contains(user.uid)
                                      ? const Icon(
                                          Icons.favorite_border,
                                          color: Colors.pinkAccent,
                                          size: 30,
                                        )
                                      : const Icon(
                                          Icons.favorite_border,
                                          color: secondaryColor,
                                          size: 30,
                                        ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${widget.snap['likes'].length}',
                                    style: TextStyle(
                                        color: widget.snap['likes']
                                                .contains(user.uid)
                                            ? Colors.pinkAccent
                                            : secondaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //Datetime
                          Text(
                            DateFormat.yMd()
                                .add_Hm()
                                .format(widget.snap['datePublished'].toDate()),
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontStyle: FontStyle.italic),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CommentsScreen(
                                    snap: widget.snap,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.mode_comment_outlined,
                                  color: secondaryColor,
                                  size: 30,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '$commentLen',
                                  style: const TextStyle(color: secondaryColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
