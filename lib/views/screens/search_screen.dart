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
                searchController.showUsers.value = false;
              } else {
                searchController.showUsers.value = true;
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
          actions: [
            ConfigButton(),
          ],
        ),
        body: searchController.showUsers.value == true
            ? ListView.builder(
                itemCount: searchController.searchedUsers.length,
                itemBuilder: (context, index) {
                  User user = searchController.searchedUsers[index];
                  return InkWell(
                    onTap: () => Get.to(() => ProfileScreen(uid: user.uid)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePic),
                      ),
                      title: Text(user.username),
                    ),
                  );
                })
            : MasonryGridView.count(
                crossAxisCount: 3,
                itemCount: searchController.publicPostList.length,
                itemBuilder: (context, index) {
                  Post post = searchController.publicPostList[index];
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: InkWell(
                      onTap: () => Get.to(() => DisplayPostScreen(post: post)),
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
      );
    });
  }
}
