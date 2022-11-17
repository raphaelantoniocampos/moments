import 'package:flutter/material.dart';
import 'package:moments/controllers/post_controller.dart';
import 'package:get/get.dart';

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
        title:
        const Text("moments"),
        actions: [
          ConfigButton(),
        ],
      ),
      body: Obx(
        () {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
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
