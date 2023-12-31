import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
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
  ScrollController _scrollController = ScrollController();
  bool visibleLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var blocWallpapers = BlocProvider.of<WallpapersBlocBloc>(context).state;
    int page = 1;
    if (blocWallpapers is loadMoreWallpapersPopulares) {
      imagesResult.addAll(blocWallpapers.imageModel);
      visibleLoading = false;
    }
    loadMore() {
      setState(() {
        page = page + 1;
      });
      BlocProvider.of<WallpapersBlocBloc>(context).add(
          LoadMoreWallpapersPopulares(category: widget.categoria, page: page));
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
            visibleLoading = true;
        loadMore();
      }
    });
    return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              BlocProvider.of<WallpapersBlocBloc>(context)
                  .add(const GetWallpapersList(category: 'curated'));
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
            style: const TextStyle(color: Colors.white),
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
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        filterQuality: FilterQuality.high,
                        opacity: 0.5,
                        image: AssetImage('assets/images/backHome.jpg'),
                        fit: BoxFit.cover)),
                child: RefreshIndicator(
                  color: Colors.black,
                  backgroundColor: buttonsBar,
                  onRefresh: () async {
                    setState(() {
                      page = page + 1;
                    });
                    BlocProvider.of<SearchBloc>(context).add(
                        SearchWallpapers(query: widget.categoria, page: page));
                  },
                  child: GridView.count(
                      controller: _scrollController,
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
                                                        imagesResult[index]
                                                            .height,
                                                    avg_colorData:
                                                        imagesResult[index]
                                                            .avgColor!)));
                                      },
                                      child: FastCachedImage(
                                        url: imagesResult[index].src!.medium!,
                                        loadingBuilder: (p0, p1) {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: buttonsBar,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                            child: Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                          );
                                        },
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: 200,
                                      ),
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: buttonsBar,
          onPressed: () {
            _scrollController.animateTo(0,
                duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
          child: visibleLoading ? CircularProgressIndicator(color: Colors.black,): const Icon(Icons.arrow_upward),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
  }
}
