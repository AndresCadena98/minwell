import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minwell/models/models.dart';
import 'package:minwell/resources/api-repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<SearchWallpapers>(_onSearchWallpapers);
  }

  FutureOr<void> _onSearchWallpapers(SearchWallpapers event, Emitter<SearchState> emit)async{
    emit(SearchLoading());
    try {
      final List<ImageModel> imageModel = await ApiRepository().fetchImagesByCategory(event.query);
      emit(SearchLoaded(imageModel: imageModel));
    } catch (e) {
      emit(SearchError());
    }
  }
}
