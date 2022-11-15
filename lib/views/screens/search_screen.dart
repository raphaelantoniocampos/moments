import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:moments/views/screens/profile_screen.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controllers/post_controller.dart';
import '../../controllers/search_controller.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../widgets/config_button.dart';
import 'display_post_screen.dart';
import 'loading_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  final SearchController searchController = Get.put(SearchController());
  final PostController postController = Get.put(PostController());
  RxBool showUsers = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const Icon(
            Icons.search,
            color: primaryColor,
          ),
          title: TextFormField(
            onChanged: (text) {
              if (text.isEmpty) {
                showUsers.value = false;
              } else {
                showUsers.value = true;
              }
              searchController.searchUser(text);
            },
            onFieldSubmitted: (text) => searchController.searchUser(text),
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.bottom,
            textInputAction: TextInputAction.search,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              hintText: 'Search for username',
              hintStyle: TextStyle(color: secondaryColor),
            ),
          ),
          actions: const [
            ConfigButton(),
          ],
        ),
        body: showUsers.value == true
            ? ListView.builder(
            itemCount: searchController.searchedUsers.length,
            itemBuilder: (context, index) {
              User user = searchController.searchedUsers[index];
              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(uid: user.uid),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePic),
                  ),
                  title: Text(user.username),
                ),
              );
            })
        // FutureBuilder(
        //         future: FirebaseFirestore.instance
        //             .collection('users')
        //             .where('username',
        //                 isGreaterThanOrEqualTo: _searchController.text)
        //             .get(),
        //         builder: (context,
        //             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        //           if (!snapshot.hasData) {
        //             return const LoadingScreen();
        //           }
        //           if (snapshot.connectionState == ConnectionState.waiting) {
        //             return const LoadingScreen();
        //           }
        //           return
        //           ListView.builder(
        //               itemCount: snapshot.data!.docs.length,
        //               itemBuilder: (context, index) {
        //                 return InkWell(
        //                   onTap: () => Navigator.of(context).push(
        //                     MaterialPageRoute(
        //                       builder: (context) => ProfileScreen(
        //                           uid: (snapshot.data! as dynamic).docs[index]
        //                               ['uid']),
        //                     ),
        //                   ),
        //                   child: ListTile(
        //                     leading: CircleAvatar(
        //                       backgroundImage: NetworkImage(
        //                           (snapshot.data! as dynamic).docs[index]
        //                               ['profilePic']),
        //                     ),
        //                     title: Text((snapshot.data! as dynamic).docs[index]
        //                         ['username']),
        //                   ),
        //                 );
        //               });
        //         })
            : MasonryGridView.count(
          crossAxisCount: 3,
          itemCount: postController.publicPostList.length,
          itemBuilder: (context, index) {
            Post post = postController.publicPostList[index];
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPostScreen(post: post),
                  ),
                ),
                child: Stack(children: [
                  Image.network(
                      post.isVideo ? post.thumbnail : post.downloadUrl),
                  Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: post.isVideo
                          ? Colors.white
                          : Colors.transparent,
                      size: 40,
                    ),
                  ),
                ]),
              ),
            );
          },
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
        ),
        //   FutureBuilder(
        //       future: FirebaseFirestore.instance
        //           .collection('posts')
        //           .where('isPublic', isEqualTo: true)
        //           .get(),
        //       builder: (context,
        //           AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
        //               snapshot) {
        //         if (!snapshot.hasData) {
        //           return const LoadingScreen();
        //         }
        //         if (snapshot.connectionState == ConnectionState.waiting) {
        //           return const LoadingScreen();
        //         }
        //         if (snapshot.connectionState == ConnectionState.none) {
        //           return const LoadingScreen();
        //         }
        //         return
        //           MasonryGridView.count(
        //           crossAxisCount: 3,
        //           itemCount: (snapshot.data! as dynamic).docs.length,
        //           itemBuilder: (context, index) => SizedBox(
        //             height: MediaQuery.of(context).size.height * 0.35,
        //             width: double.infinity,
        //             child: InkWell(
        //               onTap: () {
        //                 Navigator.of(context).push(
        //                   MaterialPageRoute(
        //                     builder: (context) => DisplayPostScreen(
        //                       post: Post.fromSnap(
        //                           (snapshot.data! as dynamic).docs[index]),
        //                     ),
        //                   ),
        //                 );
        //               },
        //               child: Stack(children: [
        //                 Image.network(
        //                   (snapshot.data! as dynamic).docs[index]['isVideo']
        //                       ? (snapshot.data! as dynamic).docs[index]
        //                           ['thumbnail']
        //                       : (snapshot.data! as dynamic).docs[index]
        //                           ['downloadUrl'],
        //                 ),
        //                 Center(
        //                   child: Icon(
        //                     Icons.play_arrow,
        //                     color: (snapshot.data! as dynamic).docs[index]
        //                             ['isVideo']
        //                         ? Colors.white
        //                         : Colors.transparent,
        //                     size: 40,
        //                   ),
        //                 ),
        //               ]),
        //             ),
        //           ),
        //           mainAxisSpacing: 0,
        //           crossAxisSpacing: 0,
        //         );
        // })
        // ,
      );
    });
  }
}



