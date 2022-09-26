import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moments/providers/user_provider.dart';
import 'package:moments/resources/firestore_methods.dart';
import 'package:moments/screens/loading_screen.dart';
import 'package:moments/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as model;
import '../screens/camera_screen.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  Uint8List? _file;
  int _page = 0;
  late PageController pageController;
  bool _isLoading = false;

  void createPost(
    String uid,
    String username,
    String profImage,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await FirestoreMethods()
          .uploadPost('', _file!, uid, username, profImage);

      if (res == 'Success') {
        showSnackBar('Posted', context);
      } else {
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void NavigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return _isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/login_screen');
                  },
                  icon: Icon(Icons.exit_to_app)),
            ),
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: HomeScreenItems,
            ),
            bottomNavigationBar: CupertinoTabBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: _page == 0 ? primaryColor : secondaryColor,
                    ),
                    label: '',
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                      color: _page == 1 ? primaryColor : secondaryColor,
                    ),
                    label: '',
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.notifications,
                      color: _page == 2 ? primaryColor : secondaryColor,
                    ),
                    label: '',
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      color: _page == 3 ? primaryColor : secondaryColor,
                    ),
                    label: '',
                    backgroundColor: primaryColor),
              ],
              onTap: NavigationTapped,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final gettingFile = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CameraScreen()));
                _file = await gettingFile.readAsBytes();

                createPost(user.uid, user.username, user.photoUrl);
              },
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
          );
  }
}
