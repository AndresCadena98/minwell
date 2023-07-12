import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minwell/models/images_model.dart';
import 'package:minwell/models/video_model.dart';
import 'package:minwell/resources/api-repository.dart';

part 'wallpapers_bloc_event.dart';
part 'wallpapers_bloc_state.dart';

class WallpapersBlocBloc extends Bloc<WallpapersBlocEvent, WallpapersBlocState> {
  WallpapersBlocBloc() : super(WallpapersInitial()) {
    
    on<WallpapersBlocEvent>((event, emit) {
      // TODO: implement event handler
     
    });
     on<GetWallpapersList>(_getWallpapersList);
     on<LoadMoreWallpapersPopulares>(_loadMoreWallpapersPopulares);
  }

  FutureOr<void> _getWallpapersList(GetWallpapersList event, Emitter<WallpapersBlocState> emit)async{
    final ApiRepository apiRepository = ApiRepository();

     try {
        emit(WallpapersLoading());
        final mList = await apiRepository.fetchImages(event.category);
        final videoList  = await apiRepository.fetchVideos();
        final imageModelPopulares = await apiRepository.fetchImagenesPopulares();
        emit(WallpapersLoaded(imageModel: mList, videoModel: videoList, imageModelPopulares: imageModelPopulares));
        
      } on NetworkError {
        emit(const WallpapersError(message:"Failed to fetch data. is your device online?"));
      }
  }

  FutureOr<void> _loadMoreWallpapersPopulares(LoadMoreWallpapersPopulares event, Emitter<WallpapersBlocState> emit)async{
    final ApiRepository apiRepository = ApiRepository();
    print('cargando mas imagenes');
     try {


        final image = await apiRepository.fetchImagesByCategory(event.category, event.page);
        emit(loadMoreWallpapersPopulares(imageModel: image, videoModel: [], imageModelPopulares: []));
        
      } on NetworkError {
        emit(const WallpapersError(message:"Failed to fetch data. is your device online?"));
      }
  }
}
