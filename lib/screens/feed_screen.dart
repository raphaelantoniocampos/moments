import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moments/screens/loading_screen.dart';
import 'package:moments/utils/colors.dart';
import 'package:moments/widgets/post_card.dart';

import '../utils/global_variables.dart';
import '../widgets/config_button.dart';
import 'login_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: width > webScreenSize
          ? null
          : AppBar(
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) =>
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width > webScreenSize ? width * 0.3 : 0,
                      vertical: width > webScreenSize ? 15 : 0),
                  child: PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                ),
          );
        },
      ),
    );
  }
}
