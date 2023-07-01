part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  
  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<ImageModel> imageModel;
  SearchLoaded({required this.imageModel});
  @override
  List<Object> get props => [imageModel];
}

class SearchError extends SearchState {}
