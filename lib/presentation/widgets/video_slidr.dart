import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:minwell/bloc/blocs.dart';
import 'package:minwell/presentation/presentation.dart';

class VideoSlider extends StatefulWidget {
  WallpapersLoaded state;
  VideoSlider({super.key, required this.state});

  @override
  State<VideoSlider> createState() => _VideoSliderState();
}

class _VideoSliderState extends State<VideoSlider> {
  List videosDisponebles = [];
  videoError(){
    print('error');
  }
  @override
  Widget build(BuildContext context) {
    widget.state.videoModel.forEach((element) {
        widget.state.videoModel.forEach((element) {
          videosDisponebles = element.videoFiles!;
        });
    
    });
    return SizedBox(
      height: 300,
      child: AnimationLimiter(
        child: GridView.builder(
          physics: const ScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: videosDisponebles.length,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            mainAxisExtent: 300,
          ),
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: 1,
              child: ScaleAnimation(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn, 
                child: FadeInAnimation(
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onTap: () {
                        print(widget.state.videoModel[index].videoFiles!.length);
                        print('Link del video');
                        print(widget.state.videoModel[index].videoPictures!.length);
                        
                        Navigator.of(context).push(
                          MaterialPageRoute(builder:(context) => VideoDetail(video:widget.state.videoModel[index].videoFiles![index].link, title: widget.state.videoModel[index].user!.name,))
                        ).catchError((onError){
                           onError = videoError();
                           
                        });
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: widget.state.videoModel[index].image!,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    LoadingAnimationWidget.fallingDot(
                              color: Colors.white,
                              size: 200,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
