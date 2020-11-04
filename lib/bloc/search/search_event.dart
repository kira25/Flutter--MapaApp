part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class OnActivarMarcadorManual extends SearchEvent {}

class OnDesactivarMarcadorManual extends SearchEvent {}

class OnAddHistorial extends SearchEvent {
  final SearchResult result;

  OnAddHistorial(this.result);
}

