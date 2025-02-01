import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({Key? key, required this.path}) : super(key: key);

  final String path;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(File(widget.path))
      ..initialize().then((value) {
        setState(() {});
      }).catchError((Object e) {
        print('catch error : ${e.toString()}');
      });
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Video Preview"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            (videoPlayerController!.value.isInitialized)
                ? AspectRatio(
                    aspectRatio: videoPlayerController!.value.aspectRatio,
                    child: VideoPlayer(videoPlayerController!),
                  )
                : const Center(child: CircularProgressIndicator()),
            Row(
              mainAxisAlignment:
                  (videoPlayerController!.value.isPlaying) ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
              children: [
                IconButton(
                  color: Colors.white,
                  onPressed: () async {
                    try {
                      await videoPlayerController!.play();
                      print("video played started .");
                      setState(() {});
                    } catch (e) {
                      print("error : $e");
                    }
                  },
                  icon: const Icon(
                    Icons.play_circle,
                    size: 40,
                  ),
                ),
                (videoPlayerController!.value.isPlaying)
                    ? IconButton(
                        color: Colors.white,
                        onPressed: () async {
                          try {
                            await videoPlayerController!.pause();
                            print("video played paused .");
                            setState(() {});
                          } catch (e) {
                            print("error : $e");
                          }
                        },
                        icon: const Icon(
                          CupertinoIcons.pause_circle,
                          size: 40,
                        ),
                      )
                    : const Center(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
