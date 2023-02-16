import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moments/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../controllers/post_controller.dart';
import '../../models/user.dart' as model;
import '../../constants.dart';
import 'camera_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 1;
  late PageController pageController;
  bool _isLoading = false;
  PostController postController = Get.put(PostController());

  void createPost(
    File file,
  ) async {
    setState(() {
      _isLoading = true;
    });

    await postController.uploadPost(file);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // AuthController authController = Get.put(AuthController());
    addData();
  }

  addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    if (user == null || _isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        body: pages[_page],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: backgroundColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
              ),
              label: 'search',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
                size: 30,
              ),
              label: 'messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: 'profile',
            ),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
              postController.updateData();
            });
          },
          currentIndex: _page,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final file = await Get.to(() => const CameraScreen());
            createPost(file);
          },
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ),
      );
    }
  }
}
