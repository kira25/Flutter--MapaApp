part of 'search_bloc.dart';

@immutable
class SearchState {
  final bool seleccionManual;
  final List<SearchResult> historial;

  SearchState({this.seleccionManual = false, List<SearchResult> historial})
      : this.historial = (historial == null) ? [] : historial;

  SearchState copyWith({bool seleccionManual, List<SearchResult> historial}) =>
      SearchState(
          seleccionManual: seleccionManual ?? this.seleccionManual,
          historial: historial ?? this.historial);
}
