part of 'place_suggestions_bloc.dart';

@immutable
class PlaceSuggestionsEvent {}

class PlaceSuggestionsLoad extends PlaceSuggestionsEvent {}

class PlaceSuggestionsSearch extends PlaceSuggestionsEvent {
  String text;
  PlaceSuggestionsSearch({required this.text});
}
