import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:minwell/bloc/blocs.dart';
import 'package:minwell/commons/commons.dart';
import 'package:minwell/models/models.dart';
import 'package:minwell/presentation/presentation.dart';

class SearchWallpapersDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      textTheme: const TextTheme(
        // Use this to change the query's text style
        headline6: TextStyle(fontSize: 24.0, color: Colors.white),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,

        // Use this change the placeholder's text style
        hintStyle: TextStyle(fontSize: 24.0),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    var blocWallpapers = BlocProvider.of<WallpapersBlocBloc>(context).state;

    List<ImageModel> imagesResult = [];
    int page = 1;
    ScrollController _scrollController = ScrollController();
    loadMore() {
      page = page + 1;
      BlocProvider.of<SearchBloc>(context)
          .add(SearchWallpapers(query: query, page: page));
    }

    if (blocWallpapers is loadMoreWallpapersPopulares) {
      imagesResult.addAll(blocWallpapers.imageModel);
    }
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        _scrollController.addListener(() {
          if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
            loadMore();
          }
        });
        if (state is SearchLoaded) {
          imagesResult = state.imageModel;
        }
        if (state is SearchError) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    filterQuality: FilterQuality.high,
                    image: AssetImage('assets/images/backHome.jpg'),
                    fit: BoxFit.cover)),
            child: const Center(
                child: Text(
              'Sin resultados',
              style: TextStyle(color: Colors.white),
            )),
          );
        }
        if (state is SearchLoading) {
          return Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    filterQuality: FilterQuality.high,
                    image: AssetImage('assets/images/backHome.jpg'),
                    fit: BoxFit.cover)),
            child: Center(
              child: CircularProgressIndicator(
                color: buttonsBar,
              ),
            ),
          );
        }
        return Center(
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    filterQuality: FilterQuality.high,
                    image: AssetImage('assets/images/backHome.jpg'),
                    fit: BoxFit.cover)),
            child: RefreshIndicator(
              color: Colors.black,
              backgroundColor: buttonsBar,
              onRefresh: () async {
                page = page + 1;
                BlocProvider.of<SearchBloc>(context)
                    .add(SearchWallpapers(query: query, page: page));
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
                                                    imagesResult[index].height,
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
                                    errorBuilder: (context, error, stackTrace) {
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: 1,
                image: AssetImage('assets/images/backHome.jpg'),
                fit: BoxFit.cover)),
        child: const Center(
            child: Text(
          'Busca tus wallpapers favoritos',
          style: TextStyle(color: Colors.white),
        )));
  }
}
