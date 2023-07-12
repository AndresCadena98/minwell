part of 'wallpapers_bloc_bloc.dart';

abstract class WallpapersBlocEvent extends Equatable {
  const WallpapersBlocEvent();

  @override
  List<Object> get props => [];
}


class GetWallpapersList extends WallpapersBlocEvent {
  final String category;
  const GetWallpapersList({required this.category});
}

class LoadMoreWallpapersPopulares extends WallpapersBlocEvent {
  final String category;
  final int page;
  const LoadMoreWallpapersPopulares({required this.category, required this.page});
}

class LoadMoreWallpapersRecientes extends WallpapersBlocEvent {}