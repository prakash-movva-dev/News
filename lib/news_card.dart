// Dart imports:

import 'dart:ui';

// Flutter imports:

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:news/bottom_bar.dart';

import 'package:video_player/video_player.dart';

// Package imports:

class NewsCard extends StatefulWidget {
  NewsCard({Key? key, required this.news}) : super(key: key);
  Map news;

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  final FlutterTts tts = FlutterTts();
  late VideoPlayerController _controller;
  final player = AudioPlayer(); // Create a player
  bool isPlaying = false;
  Future appPlay() async {
    await player.setVolume(0.5);
    await player.setUrl(widget.news["audio_file"]);
  }

  @override
  initState() {
    super.initState();
    tts.setLanguage('en');
    tts.setSpeechRate(0.5);
    if (widget.news["audio_file"] != null) {
      appPlay();
    }
    if (widget.news["video_file"] != null) {
      _controller = VideoPlayerController.network(
        widget.news["video_file"],
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      _controller.initialize();
      // _controller.setLooping(true);
      _controller.play();
    }

    //  tts.speak(widget.news["title"]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey _containerKey = GlobalKey();
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
          minWidth: double.maxFinite,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 0.3),
        ),
        child: RepaintBoundary(
          key: _containerKey,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                FractionallySizedBox(
                  alignment: Alignment.topCenter,
                  heightFactor: 0.4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      // VideoPlayer(_controller),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffF0f0f0),
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.news["image"],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        child: Center(
                          child: widget.news["video_file"] == null
                              ? CachedNetworkImage(
                                  imageUrl: widget.news["image"],
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )
                              : VideoPlayer(_controller),
                        ),
                      ),
                    ],
                  ),
                ),
                FractionallySizedBox(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 0.6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      FractionallySizedBox(
                        alignment: Alignment.topCenter,
                        heightFactor: 0.85,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 25, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                child: Text(widget.news["title"],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                    style: const TextStyle(
                                      // color: AppColor.onBackground,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                widget.news["description"],
                                overflow: TextOverflow.fade,
                                maxLines: 5,
                                style: const TextStyle(
                                  // color: AppColor.grey2,
                                  fontSize: 15,
                                  height: 1.5,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              // widget.news["audio_file"] == '' ||
                              //         widget.news["audio_file"] == null
                              //     ? Container()
                              //     : GestureDetector(
                              //         onTap: () async {
                              //           if (isPlaying) {
                              //             await player.pause();
                              //             setState(() {
                              //               isPlaying = false;
                              //             });
                              //           } else {
                              //             await player.play();
                              //             setState(() {
                              //               isPlaying = true;
                              //             });
                              //           }
                              //         },
                              //         child: Container(
                              //           width: 50,
                              //           height: 50,
                              //           decoration: BoxDecoration(
                              //             color: Colors.green,
                              //             borderRadius:
                              //                 BorderRadius.circular(50),
                              //           ),
                              //           child: Icon(
                              //             isPlaying
                              //                 ? Icons.play_arrow
                              //                 : Icons.pause,
                              //             color: Colors.white,
                              //             size: 30,
                              //           ),
                              //         )),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        alignment: Alignment.bottomCenter,
                        heightFactor: 0.15,
                        child: BottomBar(news: widget.news),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
