import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:minwell/bloc/blocs.dart';
import 'package:minwell/commons/commons.dart';
import 'package:minwell/presentation/presentation.dart';
import 'package:minwell/presentation/widgets/video_slidr.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final WallpapersBlocBloc _wallpaperBloc = WallpapersBlocBloc();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<WallpapersBlocBloc>(context).add(GetWallpapersList(category: 'curated'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Minwell',
            style: titleStyle,
          ),
        ),
        centerTitle: false,
        backgroundColor: background,
        actions: [
          Container(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: SearchWallpapersDelegate());
                },
                icon: Icon(Icons.search),
                color: Colors.white,
              )),
        ],
      ),
      body: BlocListener<WallpapersBlocBloc, WallpapersBlocState>(
        listener: (context, state) {
          if (state is WallpapersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: BlocBuilder<WallpapersBlocBloc, WallpapersBlocState>(
          builder: (context, state) {
            if (state is WallpapersInitial) {
              return Center(
                  child: Container(
                      color: background,
                      child:  CircularProgressIndicator(color:buttonsBar,)));
            } else if (state is WallpapersLoading) {
              return Center(
                  child: Container(
                      color: background,
                      child:  CircularProgressIndicator(color:buttonsBar,)));
            } else if (state is WallpapersLoaded) {
              return RefreshIndicator(
                color: Colors.black,
                backgroundColor: buttonsBar,
                onRefresh: () async {
                  BlocProvider.of<WallpapersBlocBloc>(context)
                      .add(GetWallpapersList(category: 'curated'));
                },
                child: Container(
                  color: background,
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CategoriSlider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Random',
                            style: contentStyle,
                          ),
                        ),
                        ImageSlider(
                          state: state,
                          isPopular: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Populares',
                            style: contentStyle,
                          ),
                        ),
                        ImageSlider(
                          state: state,
                          isPopular: true,
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is WallpapersError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(child: Text('Error'));
            }
          },
        ),
      ),
    );
  }
}
