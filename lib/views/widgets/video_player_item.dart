import 'package:flutter/material.dart';
import 'package:moments/constants.dart';
import 'package:video_player/video_player.dart';

import '../../models/post.dart';
import '../screens/loading_screen.dart';

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
        VideoPlayerController.network(widget.post.downloadUrl)
          ..initialize().then((value) {
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
    return Stack(alignment: Alignment.center, children: [
      const LoadingScreen(),
      VideoPlayer(videoPlayerController),
      // Container(
      //   width: size.width,
      //   height: size.height,
      //   decoration: const BoxDecoration(color: Colors.black),
      // ),
    ]);
  }
}
