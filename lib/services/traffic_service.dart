import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapa_app/helpers/debouncer.dart';
import 'package:mapa_app/models/driving_response.dart';
import 'package:mapa_app/models/reverse_query_response.dart';
import 'package:mapa_app/models/search_response.dart';

class TrafficService {
  //Singleton
  TrafficService._privateConstructor();

  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService() {
    return _instance;
  }

  final _dio = new Dio();
  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));

  final StreamController<SearchResponse> _sugerenciasStreamController =
      new StreamController<SearchResponse>.broadcast();
  Stream<SearchResponse> get sugerenciasStream =>
      _sugerenciasStreamController.stream;

  final _baseUrlDir = 'https://api.mapbox.com/directions/v5/';
  final _baseUrlGeo = 'https://api.mapbox.com/geocoding/v5/';
  final _apiKey =
      'pk.eyJ1Ijoia2lyYTI3IiwiYSI6ImNrZ3pvaXhxazBlZHgydnJuYjFlbXFjYjkifQ.0tA9G3N11DZhFqusWJ8gpQ';

  //Obtener las coordenadas de inicio a fin con el API
  Future<DrivingResponse> getCoordsInicioyFin(LatLng inicio, LatLng fin) async {
    print('Inicio :$inicio');
    print('Fin : $fin');
    final coordsString =
        '${inicio.longitude},${inicio.latitude};${fin.longitude},${fin.latitude}';
    final url = '${_baseUrlDir}mapbox/driving/$coordsString';
    final resp = await _dio.get(url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': _apiKey,
      'language': 'es',
    });

    print(resp.data);
    final data = DrivingResponse.fromJson(resp.data);
    print(data);

    return data;
  }

  Future<SearchResponse> getResultByQuery(
      String search, LatLng proximidad) async {
//Mapbox utiliza Longitud , Latitude

    print('Buscando!!');
    final url = '${_baseUrlGeo}mapbox.places/$search.json';

    try {
      final resp = await _dio.get(url, queryParameters: {
        'access_token': _apiKey,
        'autocomplete': 'true',
        'proximity': '${proximidad.longitude},${proximidad.latitude}',
        'language': 'es'
      });

      final data = resp.data;
      final searchresponse = searchResponseFromJson(data);
      print(data);
      print(searchresponse);
      return searchresponse;
    } catch (e) {
      return SearchResponse(features: []);
    }
  }

  void getSugerenciasPorQuery(String busqueda, LatLng proximidad) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final resultados = await this.getResultByQuery(value, proximidad);
      this._sugerenciasStreamController.add(resultados);
    };

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      debouncer.value = busqueda;
    });

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel());
  }

  Future<ReverseQueryResponse> getCoordenadasInfo(LatLng destinoCoords) async {
    final url =
        '${_baseUrlGeo}mapbox.places/${destinoCoords.longitude},${destinoCoords.latitude}.json';
    final resp = await _dio.get(url, queryParameters: {
      'access_token': _apiKey,
      'language': 'es',
    });

    print(resp.data);
    final data = reverseQueryResponseFromJson(resp.data);
    print(data);

    return data;
  }
}
