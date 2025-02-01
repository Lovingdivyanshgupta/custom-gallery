import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({Key? key, required this.path})
      : super(key: key);

  final String path;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text("Image Preview"),
        ),
        body: Center(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Image.file(
              File(path),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}

// /storage/emulated/0/Android/data/com.example.custom_gallery_poc/files
