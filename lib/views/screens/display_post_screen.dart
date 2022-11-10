import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../widgets/video_player_item.dart';

class DisplayPostScreen extends StatelessWidget {
  final Post post;

  const DisplayPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        body: Stack(
      children: [
        post.isVideo
            ? VideoPlayerItem(post: post)
            : Center(
              child: Image.network(
                  post.downloadUrl,
                  fit: BoxFit.fill,
                ),
            ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  '55',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ],
    )
        // VideoPlayerItem(),
        );
  }
}
