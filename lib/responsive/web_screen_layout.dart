import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moments/utils/global_variables.dart';

import '../utils/colors.dart';
import '../widgets/config_button.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  final searchController = TextEditingController();
  int _page = 1;
  late PageController pageController;
  bool _isLoading = false;

  void changePageTo(int page) {
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    searchController.dispose();
  }

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
        actions: [
          IconButton(
            onPressed: () => changePageTo(0),
            icon: Icon(
              Icons.search,
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => changePageTo(1),
            icon: Icon(
              Icons.home,
              color: _page == 1 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => changePageTo(2),
            icon: Icon(
              Icons.notifications,
              color: _page == 2 ? primaryColor : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => changePageTo(3),
            icon: Icon(
              Icons.person,
              color: _page == 3 ? primaryColor : secondaryColor,
            ),
          ),
          ConfigButton(),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
    );
  }
}
