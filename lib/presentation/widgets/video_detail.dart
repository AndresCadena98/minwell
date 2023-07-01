import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:minwell/commons/colors.dart';
import 'package:minwell/commons/styles.dart';
import 'package:video_player/video_player.dart';

class VideoDetail extends StatefulWidget {
  String? video;
  String? title;
  VideoDetail({super.key, this.video, this.title});

  @override
  State<VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;
  int? bufferDelay;
  @override
  void initState() {
    super.initState();
    // Initialize the controller and store the Future for later use.
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController!.dispose();
    bufferDelay = 0;
    super.dispose();
  }

  ///Inicia los controladores de video
  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(widget.video!);
    await _videoPlayerController1.initialize();
    _createChewieController();
    setState(() {});
  }

  /// Configuracion del reproductor de video
  void _createChewieController() {
    final subtitles = [
      Subtitle(
          index: 0,
          start: Duration.zero,
          end: const Duration(seconds: 10),
          text: widget.title),
    ];

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay: const Duration(seconds: 2),
      subtitle: Subtitles(subtitles),
      subtitleBuilder: (context, dynamic subtitle) => Container(
        decoration: BoxDecoration(
          color: buttonsBar,
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),

      hideControlsTimer: const Duration(seconds: 3),
      // Try playing around with some of these other options:
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
      showControls: true,
      fullScreenByDefault: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: buttonsBar,
        handleColor: Colors.black,
        backgroundColor: Colors.white,
        bufferedColor: Colors.grey,
      ),
      placeholder: Container(
        color: background,
      ),
    );
  }

  /// Guarda el video en la galeria
  ///

  saveVideo() async {
    try {
      Loader.show(context,
          overlayColor: Colors.black.withOpacity(0.6),
          progressIndicator: CircularProgressIndicator(
            color: buttonsBar,
          )); // Muestra el overlay mientras descarga la video
      String path = widget.video!;
      GallerySaver.saveVideo(path).then((value) {
        print(value);
        Loader.hide();
      });

      /// Oculta el overlay
      CherryToast(
              title: const Text('Video descargado'),
              icon: Icons.download_done,
              themeColor: buttonsBar)
          .show(context);
      // Below is a method of obtaining saved image information.
    } on PlatformException catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: _videoPlayerController1.value.isInitialized
          ? Stack(
              fit: StackFit.expand,
              children: [
                // Reproductor de video
                Expanded(child: Chewie(controller: _chewieController!)),
                // Boton de regresar
                Positioned(
                  top: 70,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                        color: buttonsBar,
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                        padding: const EdgeInsets.all(10),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )),
                  ),
                ),
                // Boton de descarga
                Positioned(
                    top: 140,
                  left: 10,
                    child: Container(
                      
                      decoration:  BoxDecoration(
                          color: buttonsBar,
                          borderRadius: BorderRadius.circular(50)),
                      child: IconButton(
                          onPressed: () {
                            saveVideo();
                          },
                          icon: const Icon(
                            Icons.download,
                            color: Colors.black,
                          )),
                    )),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
              color: buttonsBar,
            )),
    );
  }
}
