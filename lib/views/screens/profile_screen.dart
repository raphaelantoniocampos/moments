import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moments/resources/firestore_methods.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controllers/post_controller.dart';
import '../widgets/follow_button.dart';
import '../widgets/post_card.dart';
import 'loading_screen.dart';


class ProfileScreen extends StatelessWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
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
//         : Scaffold(
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
//   Column buildStatColumn(int num, String label) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           num.toString(),
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 4),
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w400,
//               color: secondaryColor,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
