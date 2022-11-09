import 'package:flutter/material.dart';

import '../models/post.dart';
import '../widgets/video_player_item.dart';

class DisplayPostScreen extends StatelessWidget {
  final Post post;
  const DisplayPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        VideoPlayerItem(post: post),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.favorite),
                ),
                const Text('55'),
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
