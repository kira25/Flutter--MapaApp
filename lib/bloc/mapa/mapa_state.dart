part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool mapReady;
  final bool dibujarRecorrido;
  final bool seguirUbicacion;
  final LatLng ubicacionCentral;

  //Polylines
  final Map<String, Polyline> polylines;
  final Map<String, Marker> markers;

  MapaState(
      {this.mapReady = false,
      this.dibujarRecorrido = false,
      this.seguirUbicacion = false,
      this.ubicacionCentral,
      Map<String, Marker> markers,
      Map<String, Polyline> polylines})
      : this.polylines = polylines ?? new Map(),
        this.markers = markers ?? new Map();

  MapaState copyWith(
          {bool mapReady,
          bool dibujarRecorrido,
          bool seguirUbicacion,
          LatLng ubicacionCentral,
          Map<String, Marker> markers,
          Map<String, Polyline> polylines}) =>
      MapaState(
          mapReady: mapReady ?? this.mapReady,
          dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
          seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
          ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
          polylines: polylines ?? this.polylines,
          markers: markers ?? this.markers);
}
