import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mapa_app/models/search_result.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is OnActivarMarcadorManual) {
      yield state.copyWith(seleccionManual: true);
    } else if (event is OnDesactivarMarcadorManual) {
      yield state.copyWith(seleccionManual: false);
    } else if (event is OnAddHistorial) {
      final exist = state.historial
          .where((result) => result.nameDestiny == event.result.nameDestiny)
          .length;
      if (exist == 0) {
        final newHistorial = [...state.historial, event.result];
        yield state.copyWith(historial: newHistorial);
      }
    }
  }
}
