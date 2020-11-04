import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_app/models/search_response.dart';
import 'package:mapa_app/models/search_result.dart';
import 'package:mapa_app/services/traffic_service.dart';

class SearchDestination extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;
  final TrafficService _trafficService;
  final LatLng proximidad;
  final List<SearchResult> historial;

  SearchDestination(this.proximidad, this.historial)
      : this.searchFieldLabel = 'Buscar',
        this._trafficService = new TrafficService();

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, SearchResult(cancel: true));
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return _construirResultadosSugerencias();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length == 0) {
      return ListView(
        children: [
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Colocar ubicacion manualmente'),
            onTap: () {
              close(
                  context,
                  SearchResult(
                      cancel: false,
                      manual: true)); //Cierra y devuelve un valor
            },
          ),
          ...this
              .historial
              .map((e) => ListTile(
                    leading: Icon(Icons.history),
                    title: Text(e.nameDestiny),
                    subtitle: Text(e.description),
                    onTap: () {
                      close(context, e);
                    },
                  ))
              .toList(),
        ],
      );
    }

    return _construirResultadosSugerencias();
  }

  Widget _construirResultadosSugerencias() {
    if (query == 0) {
      return Container();
    }

    _trafficService.getSugerenciasPorQuery(query.trim(), proximidad);

    return StreamBuilder<SearchResponse>(
      stream: _trafficService.sugerenciasStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          final lugares = snapshot.data.features;
          if (lugares.length == 0) {
            return ListTile(
              title: Text('No hay resultados con $query'),
            );
          }
          return ListView.separated(
              itemBuilder: (_, i) {
                final lugar = lugares[i];
                return ListTile(
                  leading: Icon(Icons.place),
                  title: Text(lugar.textEs),
                  subtitle: Text(lugar.placeNameEs),
                  onTap: () {
                    close(
                      context,
                      SearchResult(
                          cancel: false,
                          manual: false,
                          nameDestiny: lugar.textEs,
                          position: LatLng(lugar.center[1], lugar.center[0]),
                          description: lugar.placeNameEs),
                    );
                  },
                );
              },
              separatorBuilder: (_, index) => Divider(),
              itemCount: lugares.length);
        }
      },
    );
  }
}
