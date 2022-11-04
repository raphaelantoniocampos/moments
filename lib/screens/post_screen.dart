import 'dart:io';

import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  final File file;
  final String filePath;

  const PostScreen({Key? key, required this.file, required this.filePath})
      : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
