import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moments/controllers/profile_controller.dart';
import 'package:moments/resources/firestore_methods.dart';
import 'package:get/get.dart';
import 'package:moments/views/widgets/config_button.dart';

import '../../constants.dart';
import '../../controllers/post_controller.dart';
import '../widgets/follow_button.dart';
import '../widgets/post_card.dart';
import 'loading_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final PostController postController = Get.put(PostController());
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    profileController.updateUserId(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          return Scaffold(
            // appBar: AppBar(
            //   title: Text(
            //     'username',
            //     style: const TextStyle(fontWeight: FontWeight.bold,
            //         color: primaryColor),
            //   ),
            //   centerTitle: true,
            //   actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))],
            // ),
            body: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Image.network(
                    initialCoverPic,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      actions: [
                        ConfigButton(
                          color: Colors.black,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 130,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: secondaryColor,
                                backgroundImage:
                                    NetworkImage(initialProfilePic),
                              ),
                            ),
                            Text(
                              'username',
                              style: const TextStyle(
                                  fontSize: 13,
                                  // fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                          ],
                        ),
                        Text(
                          '150 connections',
                          style: const TextStyle(
                              fontSize: 13,
                              // fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'connect',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                          ),
                        )
                      ],
                    ),

                    // post list
                  ],
                ),
              ],
            ),
            // ListView(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(16.0),
            //       child: Column(
            //         children: [
            //           Row(
            //             children: [
            //               CircleAvatar(
            //                 backgroundColor: secondaryColor,
            //                 backgroundImage: NetworkImage(initialProfilePic),
            //                 radius: 40,
            //               ),
            //               Expanded(
            //                 flex: 1,
            //                 child: Column(
            //                   children: [
            //                     Row(
            //                       mainAxisSize: MainAxisSize.max,
            //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                       children: [
            //                         buildStatColumn(1, 'posts'),
            //                         buildStatColumn(1, 'friends'),
            //                         // buildStatColumn(30, 'followers'),
            //                       ],
            //                     ),
            //                     Row(
            //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                       children: [
            //                         authController.user.uid == 'are you'
            //                             ? FollowButton(
            //                                 text: 'Edit Profile',
            //                                 textColor: Colors.black,
            //                                 backGroundColor: backgroundColor,
            //                                 borderColor: secondaryColor,
            //                                 function: () {},
            //                               )
            //                             : authController.user.uid == 'is friend'
            //                                 ? FollowButton(
            //                                     text: 'Remove friend',
            //                                     textColor: Colors.black,
            //                                     backGroundColor: backgroundColor,
            //                                     borderColor: secondaryColor,
            //                                     function: () {},
            //                                   )
            //                                 : FollowButton(
            //                                     text: 'Add friend',
            //                                     textColor: Colors.white,
            //                                     backGroundColor: primaryColor,
            //                                     borderColor: secondaryColor,
            //                                     function: () {},
            //                                   ),
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //           Container(
            //             alignment: Alignment.centerLeft,
            //             padding: const EdgeInsets.only(top: 1),
            //             child: Text(
            //               'username',
            //               style: const TextStyle(
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //           ),
            //           // Container(
            //           //   alignment: Alignment.centerLeft,
            //           //   padding: const EdgeInsets.only(top: 1),
            //           //   child: Text(
            //           //     'description',
            //           //   ),
            //           // ),
            //         ],
            //       ),
            //     ),
            //     const Divider(),
            //     SizedBox(
            //       height: 600,
            //       // width: double.infinity,
            //       child: Obx(
            //         () {
            //           // stream: FirebaseFirestore.instance
            //           //     .collection('posts')
            //           //     .where('uid', isEqualTo: widget.uid)
            //           //     .orderBy('datePublished', descending: true)
            //           //     .snapshots(),
            //           // builder: (context,
            //           //     AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
            //           //         snapshot) {
            //           //   if (!snapshot.hasData) {
            //           //     return const LoadingScreen();
            //           //   }
            //           //   if (snapshot.connectionState == ConnectionState.waiting) {
            //           //     return const LoadingScreen();
            //           //   }
            //           return ListView.builder(
            //             scrollDirection: Axis.vertical,
            //             shrinkWrap: true,
            //             itemCount: postController.postList.length,
            //             itemBuilder: (context, index) {
            //               final data = postController.postList[index];
            //               return PostCard(
            //                 post: data,
            //               );
            //             },
            //           );
            //         },
            //       ),
            //     ),
            //   ],
            // ),
          );
        });
  }
}

// class ProfileScreen extends StatefulWidget {
//   final String uid;
//
//   const ProfileScreen({Key? key, required this.uid}) : super(key: key);
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final PostController postController = Get.put(PostController());
//   var userData = {};
//   int postLen = 0;
//   int friends = 0;
//   bool isFriend = false;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     getData();
//     super.initState();
//   }
//
//   getData() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       var userSnap = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.uid)
//           .get();
//
//       var postSnap = await FirebaseFirestore.instance
//           .collection('posts')
//           .where('uid', isEqualTo: widget.uid)
//           .get();
//
//       userData = userSnap.data()!;
//       friends = userData['friends'].length;
//       postLen = postSnap.docs.length;
//       isFriend = userSnap
//           .data()!['friends']
//           .contains(FirebaseAuth.instance.currentUser!.uid);
//
//       setState(() {});
//     } catch (err) {
//       // showSnackBar(err.toString(), context);
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? const LoadingScreen()
//         :
//     Scaffold(
//             appBar: AppBar(
//               title: Text(
//                 userData['username'],
//                 style: const TextStyle(color: primaryColor),
//               ),
//               centerTitle: false,
//             ),
//             body: ListView(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: secondaryColor,
//                             backgroundImage:
//                                 NetworkImage(userData['profilePic']),
//                             radius: 40,
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisSize: MainAxisSize.max,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     buildStatColumn(postLen, 'posts'),
//                                     buildStatColumn(friends, 'friends'),
//                                     // buildStatColumn(30, 'followers'),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     FirebaseAuth.instance.currentUser!.uid ==
//                                             widget.uid
//                                         ? FollowButton(
//                                             text: 'Edit Profile',
//                                             textColor: Colors.black,
//                                             backGroundColor: backgroundColor,
//                                             borderColor: secondaryColor,
//                                             function: () {},
//                                           )
//                                         : isFriend
//                                             ? FollowButton(
//                                                 text: 'Remove friend',
//                                                 textColor: Colors.black,
//                                                 backGroundColor:
//                                                     backgroundColor,
//                                                 borderColor: secondaryColor,
//                                                 function: () async {
//                                                   await FirestoreMethods()
//                                                       .addFriend(
//                                                           FirebaseAuth.instance
//                                                               .currentUser!.uid,
//                                                           widget.uid);
//                                                   setState(() {
//                                                     isFriend = false;
//                                                     friends--;
//                                                   });
//                                                 },
//                                               )
//                                             : FollowButton(
//                                                 text: 'Add friend',
//                                                 textColor: Colors.white,
//                                                 backGroundColor: primaryColor,
//                                                 borderColor: secondaryColor,
//                                                 function: () async {
//                                                   await FirestoreMethods()
//                                                       .addFriend(
//                                                           FirebaseAuth.instance
//                                                               .currentUser!.uid,
//                                                           widget.uid);
//                                                   setState(() {
//                                                     isFriend = true;
//                                                     friends++;
//                                                   });
//                                                 },
//                                               ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         alignment: Alignment.centerLeft,
//                         padding: const EdgeInsets.only(top: 1),
//                         child: Text(
//                           userData['username'],
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       // Container(
//                       //   alignment: Alignment.centerLeft,
//                       //   padding: const EdgeInsets.only(top: 1),
//                       //   child: Text(
//                       //     'description',
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//                 const Divider(),
//                 SizedBox(
//                   height: 600,
//                   // width: double.infinity,
//                   child: Obx(
//                     () {
//                       // stream: FirebaseFirestore.instance
//                       //     .collection('posts')
//                       //     .where('uid', isEqualTo: widget.uid)
//                       //     .orderBy('datePublished', descending: true)
//                       //     .snapshots(),
//                       // builder: (context,
//                       //     AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
//                       //         snapshot) {
//                       //   if (!snapshot.hasData) {
//                       //     return const LoadingScreen();
//                       //   }
//                       //   if (snapshot.connectionState == ConnectionState.waiting) {
//                       //     return const LoadingScreen();
//                       //   }
//                       return ListView.builder(
//                         scrollDirection: Axis.vertical,
//                         shrinkWrap: true,
//                         itemCount: postController.postList.length,
//                         itemBuilder: (context, index) {
//                           final data = postController.postList[index];
//                           return PostCard(
//                             post: data,
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }
//
Column buildStatColumn(int num, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: secondaryColor,
          ),
        ),
      ),
    ],
  );
}
