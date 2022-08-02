import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://storage.coverr.co/videos/bictqEaM7K02pMCMBssCJ4TKng01TPZHH2?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6Ijg3NjdFMzIzRjlGQzEzN0E4QTAyIiwiaWF0IjoxNjU3MjE0MTQ5fQ.Sydi-JBB80VvPu0n74wM-qiGFi0I7H1dUb7ZSkqsH7E',
    )..initialize().then((_) {
        log('initialize');
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(27, 30, 38, 1.0),
      ),
      backgroundColor: Color.fromRGBO(15, 18, 24, 1),
      body: _controller.value.isInitialized
          ? Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  },
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {
                      _controller.seekTo(Duration(
                          seconds: _controller.value.position.inSeconds - 10));
                    }
                    if (details.primaryVelocity! < 0) {
                      _controller.seekTo(Duration(
                          seconds: _controller.value.position.inSeconds + 10));
                    }
                  },
                  child: Container(
                    height: _controller.value.size.height /
                        _controller.value.size.width *
                        MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black,
                    child: Center(
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                      backgroundColor: Colors.blueGrey,
                      bufferedColor: Colors.blueGrey,
                      playedColor: Color.fromRGBO(27, 30, 38, 1.0)),
                ),
                const SizedBox(height: 20),
                //Text("00:0${position.inSeconds}/00:0${_controller.value.duration.inSeconds}"),
              ],
            )
          : Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(27, 30, 38, 1.0),
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
