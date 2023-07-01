part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class SetFavorite extends FavoritesEvent {
  final String url;
  
  SetFavorite({required this.url});

  @override
  List<Object> get props => [url];
}


class RemoveFavorite extends FavoritesEvent {
  final String url;

  RemoveFavorite({required this.url});

  @override
  List<Object> get props => [url];
}

class GetFavorites extends FavoritesEvent {
  @override
  List<Object> get props => [];
}
