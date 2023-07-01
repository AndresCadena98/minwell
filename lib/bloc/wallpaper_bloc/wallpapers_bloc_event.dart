part of 'wallpapers_bloc_bloc.dart';

abstract class WallpapersBlocEvent extends Equatable {
  const WallpapersBlocEvent();

  @override
  List<Object> get props => [];
}


class GetWallpapersList extends WallpapersBlocEvent {}