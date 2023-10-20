import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class VideoViewer extends StatefulWidget {
  final AssetEntity asset;

  const VideoViewer({
    super.key,
    required this.asset,
  });

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    if (Platform.isAndroid) {
      videoPlayerController = VideoPlayerController.contentUri(
          Uri.parse(await widget.asset.getMediaUrl() ?? ''));
    } else {
      videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(await widget.asset.getMediaUrl() ?? ''));
    }
    await videoPlayerController!.initialize();
    videoPlayerController!.addListener(() {
      if (!videoPlayerController!.value.isPlaying) {
        setState(() {});
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: videoPlayerController != null &&
              videoPlayerController!.value.isInitialized
          ? AspectRatio(
              aspectRatio: videoPlayerController!.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(
                    videoPlayerController!,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        if (videoPlayerController!.value.isPlaying) {
                          videoPlayerController!.pause();
                          setState(() {});
                        } else {
                          videoPlayerController!.play();
                          setState(() {});
                        }
                      },
                      child: videoPlayerController!.value.isPlaying
                          ? null
                          : const Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 70,
                            ),
                    ),
                  ),
                ],
              ),
            )
          : const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Loading'),
              ],
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController?.dispose();
  }
}
