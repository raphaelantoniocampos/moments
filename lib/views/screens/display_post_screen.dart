import 'package:flutter/material.dart';
import 'package:moments/views/widgets/like_button.dart';

import '../../models/post.dart';
import '../widgets/video_player_item.dart';

class DisplayPostScreen extends StatefulWidget {
  final Post post;

  const DisplayPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<DisplayPostScreen> createState() => _DisplayPostScreenState();
}

class _DisplayPostScreenState extends State<DisplayPostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            widget.post.isVideo
                ? VideoPlayerItem(post: widget.post)
                : Center(
                    child: Image.network(
                      widget.post.downloadUrl,
                      fit: BoxFit.fill,
                    ),
                  ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [LikeButton(post: widget.post)],
                ),
                const SizedBox(height: 24,)
              ],
            ),
          ],
        )
        // VideoPlayerItem(),
        );
  }
}
