part of 'place_suggestions_bloc.dart';

@immutable
class PlaceSuggestionsState {}

class PlaceSuggestionsInitial extends PlaceSuggestionsState {}

class PlaceSuggestionsLoaded extends PlaceSuggestionsState {
  bool isLoading;
  String searchText;
  List suggestions;
  PlaceSuggestionsLoaded(
      {required this.isLoading,
      required this.searchText,
      required this.suggestions});
}
