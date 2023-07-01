part of 'wallpapers_bloc_bloc.dart';

abstract class WallpapersBlocState extends Equatable {
  const WallpapersBlocState();
  
  @override
  List<Object> get props => [];
}

class WallpapersInitial extends WallpapersBlocState {}
class WallpapersLoading extends WallpapersBlocState {}
class WallpapersLoaded extends WallpapersBlocState {
  final List<ImageModel> imageModel;
  final List<VideoModel> videoModel;
  final List<ImageModel> imageModelPopulares;
  const WallpapersLoaded({required this.imageModel, required this.videoModel, required this.imageModelPopulares});
  @override
  List<Object> get props => [imageModel, videoModel, imageModelPopulares];
}
class WallpapersError extends WallpapersBlocState {
  final String message;
  const WallpapersError({required this.message});
  @override
  List<Object> get props => [message];
}
