part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchWallpapers extends SearchEvent {
  final String query;
  SearchWallpapers({required this.query});
  @override
  List<Object> get props => [query];
}
