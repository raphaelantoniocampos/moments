import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moments/providers/user_provider.dart';
import 'package:moments/resources/firestore_methods.dart';
import 'package:moments/screens/loading_screen.dart';
import 'package:moments/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as model;
import '../screens/camera_screen.dart';
import '../screens/login_screen.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import 'package:moments/screens/search_screen.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  final searchTextController = TextEditingController();
  bool _showingSearchField = false;
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
    searchTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    return user == null || _isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  if (_showingSearchField) {
                    setState(() {
                      _showingSearchField = false;
                    });
                  } else {
                    setState(() {
                      _showingSearchField = true;
                    });
                  }
                },
                icon: const Icon(Icons.search),
              ),
              title: _showingSearchField
                  ? TextFormField(
                      onChanged: (text) {
                        print(text);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SearchScreen(),
                          ),
                        );
                      },
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.bottom,
                      controller: searchTextController,
                      textInputAction: TextInputAction.search,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Search for username',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/moments_logo.svg',
                      color: Colors.white,
                      height: 50,
                    ),
              actions: [
                IconButton(
                    onPressed: () {
                      showDialog(
                        barrierColor: blackTransparent,
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shrinkWrap: true,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  child: const Text('Log out'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings))
              ],
            ),
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: homeScreenItems,
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
                // BottomNavigationBarItem(
                //     icon: Icon(
                //       Icons.search,
                //       color: _page == 1 ? primaryColor : secondaryColor,
                //     ),
                //     label: '',
                //     backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.notifications,
                      color: _page == 1 ? primaryColor : secondaryColor,
                    ),
                    label: '',
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      color: _page == 2 ? primaryColor : secondaryColor,
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
