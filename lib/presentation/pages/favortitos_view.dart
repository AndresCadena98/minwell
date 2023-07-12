import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:minwell/bloc/blocs.dart';
import 'package:minwell/commons/commons.dart';
import 'package:minwell/presentation/widgets/widgets.dart';

class FavoritePageView extends StatefulWidget {
  const FavoritePageView({super.key});

  @override
  State<FavoritePageView> createState() => _FavoritePageViewState();
}

class _FavoritePageViewState extends State<FavoritePageView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<FavoritesBloc>(context).add(GetFavorites());
  }

  @override
  Widget build(BuildContext context) {
    var wallpaperBloc = BlocProvider.of<WallpapersBlocBloc>(context).state;
    
    List<String> favorites = [];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Favoritos',
            style: titleFavoriteStyle,
          ),
        ),
        centerTitle: true,
        backgroundColor: background,
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesEmpty) {
            return Center(
                child: Text(
              'No hay favoritos',
              style: titleFavoriteStyle,
            ));
          }
          if (state is FavoritesLoaded) {
            favorites = state.favorites;
            print(favorites);
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(favorites.length, (index) {
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
                                    if (wallpaperBloc is WallpapersLoaded) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              // pass the image data to the detail page
                                              builder: (context) => ImageDetail(
                                                  urlData: favorites[index],
                                                  photographerData:
                                                      wallpaperBloc
                                                          .imageModel![index]
                                                          .photographer!,
                                                  photographerURL: wallpaperBloc
                                                      .imageModel![index]
                                                      .photographerUrl!,
                                                  widthImageData: wallpaperBloc
                                                      .imageModel![index].width
                                                      .toString(),
                                                  heightImageData: wallpaperBloc
                                                      .imageModel![index].height,
                                                  avg_colorData: wallpaperBloc
                                                      .imageModel![index]
                                                      .avgColor!)));
                                    }
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
                                      imageUrl: favorites[index]),
                                )),
                          ),
                        ),
                      ),
                    );
                  })),
            ),
          );
        },
      ),
    );
  }
}
