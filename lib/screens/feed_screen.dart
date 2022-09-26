import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moments/utils/colors.dart';
import 'package:moments/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(),
        backgroundColor: primaryColor,
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/moments_logo.svg',
          color: Colors.white,
          height: 50,
        ),
      ),
      body: const PostCard(),
    );
  }
}
