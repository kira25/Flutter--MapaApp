part of 'mi_ubicacion_bloc.dart';

@immutable
abstract class MiUbicacionEvent {}

class FollowingPositionEvent extends MiUbicacionEvent{
  final LatLng ubicacion;

  FollowingPositionEvent(this.ubicacion);
}