import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:minwell/bloc/blocs.dart';
import 'package:minwell/commons/colors.dart';
import 'package:minwell/models/models.dart';
import 'package:minwell/presentation/presentation.dart';

class ResultSearch extends StatefulWidget {
  String categoria;

  ResultSearch({super.key, required this.categoria});

  @override
  State<ResultSearch> createState() => _ResultSearchState();
}

class _ResultSearchState extends State<ResultSearch> {
  List<ImageModel> imagesResult = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        backgroundColor: background,
        title: Text(
          'Resultados de ${widget.categoria}',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoaded) {
            imagesResult = state.imageModel;
          }
          if (state is SearchError) {
            return const Center(
              child: Text('Error'),
            );
          }
          if (state is SearchLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: buttonsBar,
            ));
          }
          return Center(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    filterQuality: FilterQuality.high,
                    opacity: 0.5,
                    image: AssetImage('assets/images/backHome.jpg'), fit: BoxFit.cover)
                ),
              child: RefreshIndicator(
                color: Colors.black,
                backgroundColor: buttonsBar,
                onRefresh: () async {
                  BlocProvider.of<SearchBloc>(context)
                      .add(SearchWallpapers(query: widget.categoria));
                },
                child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(imagesResult.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          columnCount: 2,
                          child: ScaleAnimation(
                            duration: const Duration(milliseconds: 500),
                            child: FadeInAnimation(
                              duration: const Duration(milliseconds: 500),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              // pass the image data to the detail page
                                              builder: (context) => ImageDetail(
                                                  urlData: imagesResult[index]
                                                      .src!
                                                      .original!,
                                                  photographerData:
                                                      imagesResult[index]
                                                          .photographer!,
                                                  photographerURL:
                                                      imagesResult[index]
                                                          .photographerUrl!,
                                                  widthImageData:
                                                      imagesResult[index]
                                                          .width
                                                          .toString(),
                                                  heightImageData:
                                                      imagesResult[index].height,
                                                  avg_colorData:
                                                      imagesResult[index]
                                                          .avgColor!)));
                                    },
                                    child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                LoadingAnimationWidget.fallingDot(
                                                  color: Colors.white,
                                                  size: 200,
                                                ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        imageUrl:
                                            imagesResult[index].src!.original!),
                                  )),
                            ),
                          ),
                        ),
                      );
                    })),
              ),
            ),
          );
        },
      ),
    );
  }
}
