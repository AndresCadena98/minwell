part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  
  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<String> favorites;
  final bool isFavorite;
  FavoritesLoaded({required this.favorites, required this.isFavorite});

  @override
  List<Object> get props => [favorites, isFavorite];
}

class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError({required this.message});

  @override
  List<Object> get props => [message];
}

class FavoritesEmpty extends FavoritesState {
  final String message;

  FavoritesEmpty({required this.message});

  @override
  List<Object> get props => [message];
}