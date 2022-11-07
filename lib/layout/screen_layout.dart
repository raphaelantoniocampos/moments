import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moments/providers/user_provider.dart';
import 'package:moments/screens/loading_screen.dart';
import 'package:provider/provider.dart';

import '../controllers/upload_post_controller.dart';
import '../models/user.dart' as model;
import '../screens/camera_screen.dart';
import '../utils/constants.dart';

class ScreenLayout extends StatefulWidget {
  const ScreenLayout({Key? key}) : super(key: key);

  @override
  State<ScreenLayout> createState() => _ScreenLayoutState();
}

class _ScreenLayoutState extends State<ScreenLayout> {
  final searchController = TextEditingController();
  late final String filePath;
  int _page = 1;
  late PageController pageController;
  bool _isLoading = false;
  UploadPostController uploadPostController = Get.put(UploadPostController());

  void createPost(
    String uid,
    File file,
  ) async {
    setState(() {
      _isLoading = true;
    });

    await uploadPostController.uploadPost(file);
    // String res =
    //     await FirestoreMethods().uploadPost('', file!, uid);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    addData();
    super.initState();
  }

  addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    return user == null || _isLoading
        ? const LoadingScreen()
        : Scaffold(
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
                    Icons.notifications,
                    size: 30,
                  ),
                  label: 'notifications',
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
                });
              },
              currentIndex: _page,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final file = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(),
                  ),
                );

                createPost(user.uid, file);
              },
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
          );
  }
}
