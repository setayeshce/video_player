import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MaterialApp(
    home: CustomVideoPlayer(
      // video
      videoUrl: 'https://cdn.bitmovin.com/content/assets/art-of-motion-dash-hls-progressive/mpds/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.mpd',
     //voice
    // videoUrl: 'https://rixoway.arvanvod.ir/yz2g7XR5rQ/7OxEq0Wqge/h_,64_64,96_96,128_128,k.mp4.list/manifest.mpd',
      buttonPhrases: [
        'Phrase 1',
        'Phrase 2',
        'Phrase 3',
        'Phrase 4',
        'Phrase 5',
        'Phrase 6',
      ],
    ),
  ));
}

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final List<String> buttonPhrases;

  CustomVideoPlayer({required this.videoUrl, required this.buttonPhrases});

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  ChewieController? _chewieController;
  bool _isPlaying = false;
  bool _isTimerFinished = false;
  bool finishTime = false;
  int _countdown = 10;
  List<Color> shuffledColors = [];
  List<String> shuffledPhrases = [];
  Timer? _countdownTimer;
  var orientationValue;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    shuffledColors = getRandomColors();
    shuffledPhrases = _shuffleButtonPhrases();
  }

  @override
  void dispose() {
    _chewieController!.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void _initializeVideoPlayer() async {
    final videoPlayerController = VideoPlayerController.networkUrl(
    Uri.parse(widget.videoUrl)  ,
    );
    await videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: false,
      showControls: true,
      allowFullScreen: true,
      aspectRatio: videoPlayerController.value.aspectRatio,
    );
    videoPlayerController.addListener(() {
      if (videoPlayerController.value.position >= videoPlayerController.value.duration) {
        _startCountdown();
      }
    });
  }

  void _playPauseVideo() {
    setState(() {
      if (_chewieController!.videoPlayerController.value.isPlaying) {
        _chewieController!.pause();
        _isPlaying = false;
      } else {
        _chewieController!.play();
        _isPlaying = true;
      }
    });
  }

  void _startCountdown() {
    setState(() {
      _isTimerFinished = false;
      _chewieController!.pause();
      _isPlaying = false;
    });
    _cancelTimer();
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
        if (_countdown <= 3) {
          setState(() {
            finishTime = true;
          });
        }
      } else {
        timer.cancel();
        setState(() {
          _isTimerFinished = true;
        });
      }
    });
  }

  void _cancelTimer() {
    if (_countdownTimer != null && _countdownTimer!.isActive) {
      _countdownTimer!.cancel();
    }
  }

  List<String> _shuffleButtonPhrases() {
    List<String> shuffledPhrases = List.from(widget.buttonPhrases);
    shuffledPhrases.shuffle();
    return shuffledPhrases;
  }

  List<Color> getRandomColors() {
    List<Color> colors = [Colors.red, Colors.green];
    colors.shuffle();
    return colors;
  }

  @override
  Widget build(BuildContext context) {
    var pageW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text('Video Player'),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        orientationValue = orientation;
        return SafeArea(
          child: Stack(
            children: [
              Container(
                color: Colors.black12,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  color: Colors.black87,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_chewieController != null && _chewieController!.videoPlayerController.value.isInitialized)
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: orientationValue == Orientation.landscape ? pageW * 0.01 : pageW * 0.2),
                          child: Center(
                            child: SizedBox(
                              height: orientationValue == Orientation.landscape ? pageW * 0.25 : pageW * 0.5,
                              width: orientationValue == Orientation.landscape ? pageW * 0.45 : pageW * 0.9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Chewie(
                                  controller: _chewieController!,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: orientationValue == Orientation.landscape ? pageW * 0.015 : pageW * 0.23,
                          right: orientationValue == Orientation.landscape ? pageW * 0.3 : pageW * 0.1,
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                finishTime ? Colors.red : Color(0xFF01579B),
                                finishTime ? Colors.redAccent : Color(0xFF02C39A),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              '$_countdown',
                              style: const TextStyle(fontSize: 40.0, color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: orientationValue == Orientation.landscape ? pageW * 0.06 : pageW * 0.44, bottom: pageW * 0.15),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: orientationValue == Orientation.landscape ? 8 : 16),
                        if (orientationValue != Orientation.landscape)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _chewieController!.seekTo(Duration(seconds: _chewieController!.videoPlayerController.value.position.inSeconds - 15));
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[300],
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Icon(Icons.replay_5_outlined)),
                              ),
                              InkWell(
                                onTap: _playPauseVideo,
                                child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[300],
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Icon(_isPlaying ? Icons.pause_outlined : Icons.play_arrow)),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _chewieController!.seekTo(Duration(seconds: _chewieController!.videoPlayerController.value.position.inSeconds + 15));
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[300],
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Icon(Icons.forward_10)),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _chewieController!.seekTo(Duration.zero);
                                    _countdown = 10;
                                    finishTime = false;
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[300],
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Icon(Icons.repeat)),
                              ),
                            ],
                          ),
                        Spacer(),
                        Container(
                          height: orientationValue == Orientation.landscape ? pageW * 0.1 : pageW * 0.5,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32)),
                            color: Colors.black54,
                            boxShadow: [BoxShadow(color: Colors.grey, spreadRadius: 3)],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              boxAnswer(0), // First button with index 0
                              boxAnswer(1), // Second button with index 1
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget boxAnswer(int index) {
    var pageW = MediaQuery.of(context).size.width;
    Color buttonColor = shuffledColors[index]; // Get the corresponding shuffled color

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: orientationValue == Orientation.landscape ? pageW * 0.1 : pageW * 0.15,
      width: orientationValue == Orientation.landscape ? pageW * 0.42 : pageW * 0.44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _isTimerFinished ? buttonColor : Colors.white,
      ),
      child: Center(
        child: Text(
          shuffledPhrases[index],
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
