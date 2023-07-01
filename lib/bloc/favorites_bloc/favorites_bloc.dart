import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial()) {
    on<FavoritesEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<SetFavorite>(_onSetFavorite);
    on<GetFavorites>(_onGetFavorites);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  FutureOr<void> _onSetFavorite(
      SetFavorite event, Emitter<FavoritesState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.add(event.url);
    prefs.setStringList('favorites', favorites);
    emit(FavoritesLoaded(favorites: favorites, isFavorite: true));
  }

 

  FutureOr<void> _onGetFavorites(GetFavorites event, Emitter<FavoritesState> emit)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    if(favorites.isEmpty){
      emit(FavoritesEmpty(message: 'No hay favoritos'));
    }else{
      emit(FavoritesLoaded(favorites: favorites, isFavorite: true));
    }

  }

  FutureOr<void> _onRemoveFavorite(RemoveFavorite event, Emitter<FavoritesState> emit)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.remove(event.url);
    prefs.setStringList('favorites', favorites);
    emit(FavoritesLoaded(favorites: favorites,isFavorite: false));
  }
}
