part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchWallpapers extends SearchEvent {
  final String query;
  final int page;
  SearchWallpapers({required this.query, required this.page});
  @override
  List<Object> get props => [query];
}
