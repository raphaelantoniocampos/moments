import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moments/screens/loading_screen.dart';
import 'package:moments/utils/colors.dart';
import 'package:moments/widgets/post_card.dart';

import '../widgets/config_button.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

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
                PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
          );
        },
      ),
    );
  }
}
