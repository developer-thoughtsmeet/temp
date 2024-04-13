dependencies:
  flutter:
    sdk: flutter
  video_player: ^2.2.12
  youtube_player_flutter: ^8.0.0
  visibility_detector: ^0.2.0
  flick_video_player: ^0.5.0


import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flick_video_player/flick_video_player.dart';

class MediaWidget extends StatefulWidget {
  final List<String> mediaUrls;

  const MediaWidget({required this.mediaUrls});

  @override
  _MediaWidgetState createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  late List<bool> _isVisible;
  late List<VideoPlayerController> _videoControllers;
  late List<FlickManager> _flickManagers;
  late YoutubePlayerController _youtubePlayerController;

  @override
  void initState() {
    super.initState();
    _isVisible = List.filled(widget.mediaUrls.length, false);
    _videoControllers = List.generate(
      widget.mediaUrls.length,
      (_) => VideoPlayerController.network(widget.mediaUrls[0]),
    );
    _flickManagers = _videoControllers
        .map((controller) => FlickManager(
              videoPlayerController: controller,
              autoPlay: false,
              autoInitialize: true,
            ))
        .toList();
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.mediaUrls[0]) ?? '',
      flags: YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    for (var manager in _flickManagers) {
      manager.dispose();
    }
    _youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.mediaUrls.length,
      itemBuilder: (context, index) {
        if (widget.mediaUrls[index].contains('youtube')) {
          return VisibilityDetector(
            key: Key(widget.mediaUrls[index]),
            onVisibilityChanged: (visibilityInfo) {
              setState(() {
                _isVisible[index] = visibilityInfo.visibleFraction == 1.0;
              });
              if (_isVisible[index]) {
                _youtubePlayerController.play();
              } else {
                _youtubePlayerController.pause();
              }
            },
            child: YoutubePlayer(
              controller: _youtubePlayerController,
              liveUIColor: Colors.amber,
            ),
          );
        } else if (widget.mediaUrls[index].contains('mp4')) {
          return VisibilityDetector(
            key: Key(widget.mediaUrls[index]),
            onVisibilityChanged: (visibilityInfo) {
              setState(() {
                _isVisible[index] = visibilityInfo.visibleFraction == 1.0;
              });
              if (_isVisible[index]) {
                _flickManagers[index].flickControlManager?.play();
              } else {
                _flickManagers[index].flickControlManager?.pause();
              }
            },
            child: FlickVideoPlayer(
              flickManager: _flickManagers[index],
              flickVideoWithControls: FlickVideoWithControls(
                playerLoadingFallback: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        } else {
          return Image.network(widget.mediaUrls[index]);
        }
      },
    );
  }
}


class MyHomePage extends StatelessWidget {
  final List<String> mediaUrls = [
    'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
    'https://www.sample-videos.com/img/Sample-jpg-image-500kb.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Player'),
      ),
      body: MediaWidget(mediaUrls: mediaUrls),
    );
  }
}
