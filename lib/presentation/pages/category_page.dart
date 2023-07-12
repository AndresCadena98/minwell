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

class CategoryPage extends StatefulWidget {
  String categoria;

  CategoryPage({super.key, required this.categoria});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<ImageModel> imagesResult = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState                                                     
    super.initState();
    imagesResult = [];
  }

  @override
  Widget build(BuildContext context) {
    var blocWallpapers = BlocProvider.of<WallpapersBlocBloc>(context).state;
    int page = 1;
    print(blocWallpapers);
    if (blocWallpapers is loadMoreWallpapersPopulares) {
      imagesResult.addAll(blocWallpapers.imageModel);
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
                  .add(GetWallpapersList(category: 'curated'));
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
        body: BlocBuilder<WallpapersBlocBloc, WallpapersBlocState>(
          builder: (context, state) {
            if (state is WallpapersLoaded) {
              imagesResult = state.imageModel;
            }
            if (state is WallpapersError) {
              return const Center(
                child: Text('Error'),
              );
            }
            if (state is WallpapersLoading) {
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
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
          child: Icon(Icons.arrow_upward),
        ));
  }
}
