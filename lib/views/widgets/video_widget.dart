import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../models/post.dart';

class VideoWidget extends StatefulWidget {
  final Post post;

  const VideoWidget({Key? key, required this.post}) : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.post.downloadUrl);
    _initializeVideoFuture = _controller.initialize().then((_) {
      _controller.setVolume(1);
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

