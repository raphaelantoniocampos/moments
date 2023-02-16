import 'package:flutter/material.dart';
import 'package:moments/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:moments/views/screens/user_list_screen.dart';
import 'package:moments/views/widgets/config_button.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/user_provider.dart';
import '../widgets/image_widget.dart';
import '../widgets/post_card.dart';
import '../../models/user.dart' as model;

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    userController.updateUserId(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
        init: UserController(),
        builder: (controller) {
          final model.User? currentUser = Provider.of<UserProvider>(context).getUser;
          if (controller.user.isEmpty || currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Image.network(
                          controller.user['coverPic'],
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
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: InkWell(
                              onTap: (){
                                Get.to(
                                      () => ImageWidget(
                                    url: controller.user['profilePic'],
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: secondaryColor,
                                backgroundImage:
                                    NetworkImage(controller.user['profilePic']),
                              ),
                            ),
                          ),
                          Text(
                            controller.user['username'],
                            style: const TextStyle(
                                fontSize: 13,
                                // fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                        ],
                      ),
                      InkWell(
                        child: Text(
                          '${controller.user['friends'].length} friends',
                          style: const TextStyle(
                              fontSize: 13,
                              // fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        onTap: () {
                          Get.to(() => UserListScreen(title: 'Friends',
                              uidList: controller.user['friends']));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: widget.uid == authController.user.uid
                            ? TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'edit',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                              )
                            : controller.user['isFriend']
                                ? TextButton(
                                    onPressed: () => userController.addFriend(),
                                    child: const Text(
                                      'remove friend',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent),
                                    ),
                                  )
                                : controller.user['wasAsked']
                                    ? TextButton(
                                        onPressed: () =>
                                            userController.addFriend(),
                                        child: const Text(
                                          'asked',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor),
                                        ),
                                      )
                                    : controller.user['friends'].length >= limitFriends
                                        ? TextButton(
                                            onPressed: () {},
                                            child: const Text(
                                              'user limited',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.redAccent),
                                            ),
                                          )
                                        : currentUser.friends.length < limitFriends
                                            ? TextButton(
                                                onPressed: () =>
                                                    userController.addFriend(),
                                                child: const Text(
                                                  'add friend',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor),
                                                ),
                                              )
                                            : TextButton(
                                                onPressed: () {},
                                                child: const Text(
                                                  'max connections',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.redAccent),
                                                ),
                                              ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: controller.postList.length,
                      itemBuilder: (context, index) {
                        return PostCard(post: controller.postList[index]);
                      }),
                ],
              ),
            ),
          );
        });
  }
}

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
