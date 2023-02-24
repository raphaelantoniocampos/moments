import 'package:flutter/material.dart';
import 'package:moments/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:moments/views/screens/user_list_screen.dart';
import 'package:moments/views/widgets/config_button.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/user.dart';
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
          final model.User? currentUser =
              Provider.of<UserProvider>(context).getUser;
          if (controller.user.isEmpty || currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: InkWell(
                                onTap: () {
                                  Get.to(
                                    () => ImageWidget(
                                      url: controller.user['profilePic'],
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.black,
                                  backgroundImage: NetworkImage(
                                      controller.user['profilePic']),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.user['username'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => UserListScreen(
                                          title: 'Friends',
                                          uidList: controller.user['friends']));
                                    },
                                    child: Text(
                                      '${controller.user['friends'].length} friends',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: buildButton(controller, currentUser),
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

  Widget buildButton(UserController controller, User currentUser) {
    final isCurrentUser = widget.uid == authController.user.uid;
    final isFriend = controller.user['isFriend'];
    final wasAsked = controller.user['wasAsked'];
    final friendCount = controller.user['friends'].length;
    final currentUserFriendCount = currentUser.friends.length;

    if (isCurrentUser) {
      return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.edit,
              size: 15,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              'Edit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Helvetica Neue',
              ),
            ),
          ],
        ),
      );
    } else if (isFriend) {
      return ElevatedButton(
        onPressed: () => userController.addFriend(),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.person_remove,
              size: 15,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              'Remove friend',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Helvetica Neue',
              ),
            ),
          ],
        ),
      );
    } else if (wasAsked) {
      return ElevatedButton(
        onPressed: () => userController.addFriend(),
        style: ElevatedButton.styleFrom(
          foregroundColor: primaryColor,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.watch_later_outlined,
              size: 15,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              'Asked',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Helvetica Neue',
              ),
            ),
          ],
        ),
      );
    } else if (friendCount >= limitFriends) {
      return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.block,
              size: 15,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              'User limited',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Helvetica Neue',
              ),
            ),
          ],
        ),
      );
    } else if (currentUserFriendCount < limitFriends) {
      return ElevatedButton(
        onPressed: () => userController.addFriend(),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.person_add,
              size: 15,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              'Add friend',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Helvetica Neue',
              ),
            ),
          ],
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.block,
              size: 15,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              'Max friends',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Helvetica Neue',
              ),
            ),
          ],
        ),
      );
    }
  }
}
