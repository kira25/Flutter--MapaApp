part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

//Cuando el mapa esta listo
class OnMapaReady extends MapaEvent {}

class OnPaintRoute extends MapaEvent {}

class OnMoveCentralMap extends MapaEvent{
  final LatLng centroMapa;

  OnMoveCentralMap(this.centroMapa);
}

class OnFollowLocation extends MapaEvent {}

class OnLocationUpdate extends MapaEvent {
  final LatLng ubicacion;

  OnLocationUpdate(this.ubicacion);
}


class OnCreateRouteDestiny extends MapaEvent{
  final List<LatLng> rutaCoordenadas;
  final double distancia;
  final double duracion;
  final String nameDestiny;

  OnCreateRouteDestiny(this.rutaCoordenadas, this.distancia, this.duracion, this.nameDestiny);
}