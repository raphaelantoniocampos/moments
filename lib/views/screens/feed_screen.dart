import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moments/controllers/post_controller.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../widgets/config_button.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  FeedScreen({Key? key}) : super(key: key);

  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/moments_logo.svg',
          color: primaryColor,
          height: 50,
        ),
        actions: const [
          ConfigButton(),
        ],
      ),
      body: Obx(
        () {
          // stream: FirebaseFirestore.instance
          //     .collection('posts')
          //     .orderBy('datePublished', descending: true)
          //     .snapshots(),
          // builder: (context,
          //     AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          //   if (snapshot.connectionState == ConnectionState.waiting) {
          //     return const LoadingScreen();
          //   }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            reverse: true,
            itemCount: postController.postList.length,
            itemBuilder: (context, index) {
              final data = postController.postList[index];
              return PostCard(
                post: data,
              );
            },
          );
        },
      ),
    );
  }
}
