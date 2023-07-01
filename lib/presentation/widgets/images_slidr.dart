import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:minwell/bloc/blocs.dart';
import 'package:minwell/commons/colors.dart';
import 'package:minwell/presentation/presentation.dart';

class ImageSlider extends StatefulWidget {
  WallpapersLoaded state;
  bool isPopular;
  ImageSlider({super.key, required this.state, required this.isPopular});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: AnimationLimiter(
        child: GridView.builder(
          physics: const ScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.isPopular
              ? widget.state.imageModelPopulares.length
              : widget.state.imageModel.length,
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
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          key: widget.isPopular
                              ? ValueKey(
                                  widget.state.imageModelPopulares[index].id)
                              : ValueKey(widget.state.imageModel[index].id!),
                          onTap: () {
                            if (!widget.isPopular) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  // pass the image data to the detail page
                                  builder: (context) => ImageDetail(
                                      urlData: widget.state.imageModel[index]
                                          .src!.original!,
                                      photographerData: widget.state
                                          .imageModel[index].photographer!,
                                      photographerURL: widget.state
                                          .imageModel[index].photographerUrl!,
                                      widthImageData: widget
                                          .state.imageModel[index].width
                                          .toString(),
                                      heightImageData:
                                          widget.state.imageModel[index].height,
                                      avg_colorData: widget
                                          .state.imageModel[index].avgColor!)));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  // pass the image data to the detail page
                                  builder: (context) => ImageDetail(
                                      urlData: widget
                                          .state
                                          .imageModelPopulares[index]
                                          .src!
                                          .original!,
                                      photographerData: widget
                                          .state
                                          .imageModelPopulares[index]
                                          .photographer!,
                                      photographerURL: widget
                                          .state
                                          .imageModelPopulares[index]
                                          .photographerUrl!,
                                      widthImageData: widget.state
                                          .imageModelPopulares[index].width
                                          .toString(),
                                      heightImageData: widget.state
                                          .imageModelPopulares[index].height,
                                      avg_colorData: widget
                                          .state
                                          .imageModelPopulares[index]
                                          .avgColor!)));
                            }
                          },
                          child: CachedNetworkImage(
                            imageUrl: widget.isPopular
                                ? widget.state.imageModelPopulares[index].src!
                                    .original!
                                : widget.state.imageModel[index].src!.original!,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    LoadingAnimationWidget.fallingDot(
                              color: buttonsBar,
                              size: 200,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        )),
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
