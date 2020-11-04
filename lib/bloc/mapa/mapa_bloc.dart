import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors, Offset;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_app/helpers/helpers.dart';
import 'package:mapa_app/themes/uber_theme.dart';
import 'package:meta/meta.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(MapaState());

  //Map controller
  GoogleMapController _mapController;

  //Polylines
  Polyline _miRuta = new Polyline(
      polylineId: PolylineId('mi_ruta'), width: 4, color: Colors.transparent);
  Polyline _miRutaDestino = new Polyline(
      polylineId: PolylineId('mi_ruta_destino'), width: 4, color: Colors.blue);

  void initMap(GoogleMapController controller) {
    if (!state.mapReady) {
      _mapController = controller;
      //estilo del mapa
      _mapController.setMapStyle(jsonEncode(uberMapTheme));
      add(OnMapaReady());
    }
  }

  void moveCamera(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(
    MapaEvent event,
  ) async* {
    if (event is OnMapaReady) {
      yield state.copyWith(mapReady: true);
    } else if (event is OnLocationUpdate) {
      yield* _onLocationUpdate(event); // no regreses el stream sino la emision
    } else if (event is OnPaintRoute) {
      print(event);
      yield* _onPaintRoute(event);
    } else if (event is OnFollowLocation) {
      yield* _onFollowLocation(event);
    } else if (event is OnMoveCentralMap) {
      yield state.copyWith(ubicacionCentral: event.centroMapa);
    } else if (event is OnCreateRouteDestiny) {
      yield* _onCreateRouteDestiny(event);
    }
  }

  Stream<MapaState> _onPaintRoute(OnPaintRoute event) async* {
    //En caso no este activado dibujarRecorrido
    if (!state.dibujarRecorrido) {
      _miRuta = _miRuta.copyWith(colorParam: Colors.black87);
    } else {
      _miRuta = _miRuta.copyWith(colorParam: Colors.transparent);
    }
    //extraer polylines
    final currentPolylines = state.polylines;
    //añadiamos la anterior
    currentPolylines['mi_ruta'] = _miRuta;
    yield state.copyWith(
        dibujarRecorrido: !state.dibujarRecorrido, polylines: currentPolylines);
  }

  Stream<MapaState> _onLocationUpdate(OnLocationUpdate event) async* {
    List<LatLng> points = [...this._miRuta.points, event.ubicacion];
    _miRuta = _miRuta.copyWith(pointsParam: points);

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = _miRuta;
    yield state.copyWith(polylines: currentPolylines);
  }

  Stream<MapaState> _onFollowLocation(OnFollowLocation event) async* {
    if (!state.seguirUbicacion) {
      moveCamera(_miRuta.points[_miRuta.points.length - 1]);
    }
    yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);
  }

  Stream<MapaState> _onCreateRouteDestiny(OnCreateRouteDestiny event) async* {
    //asignamos nueva ruta
    _miRutaDestino =
        _miRutaDestino.copyWith(pointsParam: event.rutaCoordenadas);
    //asignamos los polylines
    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta_destino'] = _miRutaDestino;

    //Icono inicio
    // final iconoInicio = await getAssetImageMarker();
    final iconoInicio = await getMarkerInicioIcon(event.duracion.toInt());
    // final iconoFin = await getNetworkImageMarker();
    final iconoFin =
        await getMarkerDestinoIcon(event.nameDestiny, event.distancia);

//Markers
    final markerInicio = new Marker(
        markerId: MarkerId('inicio'),
        anchor: Offset(0.0, 1.0),
        icon: iconoInicio,
        position: event.rutaCoordenadas[0],
        infoWindow: InfoWindow(
            onTap: () {
              print('Info Window');
            },
            title: 'Mi ubicacion',
            snippet:
                'Duracion recorrido : ${(event.duracion / 60).floor()} minutos'));

    double kilometers = event.distancia;
    kilometers = (kilometers * 100).floorToDouble();
    kilometers = kilometers / 100;

    final markerFinal = new Marker(
        anchor: Offset(1.0, 0.95),
        icon: iconoFin,
        markerId: MarkerId('final'),
        infoWindow: InfoWindow(
            title: event.nameDestiny,
            snippet: 'Distancia a recorrer: $kilometers km'),
        position: event.rutaCoordenadas[event.rutaCoordenadas.length - 1]);

    final newMarkers = {...state.markers};
    newMarkers['inicio'] = markerInicio;
    newMarkers['final'] = markerFinal;

    // Future.delayed(Duration()).then((value) {
    //   // _mapController.showMarkerInfoWindow(MarkerId('inicio'));
    //   _mapController.showMarkerInfoWindow(MarkerId('final'));
    // });

    yield state.copyWith(polylines: currentPolylines, markers: newMarkers);
  }
}
