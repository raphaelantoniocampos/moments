import 'package:flutter/material.dart';
import 'package:moments/utils/constants.dart';
import 'package:video_player/video_player.dart';

import '../models/post.dart';

class VideoPlayerItem extends StatefulWidget {
  final Post post;

  const VideoPlayerItem({Key? key, required this.post}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    videoPlayerController =
        VideoPlayerController.network(widget.post.downloadUrl)..initialize().then((value) {
          videoPlayerController.play();
          videoPlayerController.setVolume(1);
        });
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(color: backgroundColor),
      child: VideoPlayer(videoPlayerController),
    );
  }
}
