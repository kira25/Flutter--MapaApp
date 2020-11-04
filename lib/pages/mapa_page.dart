import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapa_app/widgets/widgets.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  CameraPosition mapPosition;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Monitorear la posicion del usuario en todo momento
    context.bloc<MiUbicacionBloc>().iniciarSeguimiento();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //Dejar de escuchar la posicion del usuario
    context.bloc<MiUbicacionBloc>().disposeSeguimiento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BtnUbicacion(),
          BtnMiRuta(),
          BtnSeguirUbicacion(),
        ],
      ),
      body: Stack(
        children: [
          BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
            builder: (_, state) => crearMapa(state),
          ),
          Positioned(child: SearchBar()),
          MarcadoManual()
        ],
      ),
    );
  }

  Widget crearMapa(MiUbicacionState state) {
    //Detectando la ubicacion actual
    if (!state.existeUbicacion) return Center(child: Text('Ubicando..'));

    final initialCameraPosition =
        CameraPosition(target: state.ubicacion, zoom: 15);
    final mapaBloc = BlocProvider.of<MapaBloc>(context);
    //Actualizar la posicion almacenando los puntos recorridos
    mapaBloc.add(OnLocationUpdate(state.ubicacion));

    return BlocBuilder<MapaBloc, MapaState>(
      builder: (context, _) {
        return GoogleMap(
          zoomControlsEnabled: false,
          initialCameraPosition: initialCameraPosition,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          compassEnabled: true,
          onMapCreated: mapaBloc.initMap,
          polylines: mapaBloc.state.polylines.values.toSet(),
          markers: mapaBloc.state.markers.values.toSet(),
          onCameraMove: (position) {
            //Obtenemos el centro del mapa para utilizarlo en el marcador manual
            final newPosition = position.target;
            mapaBloc.add(OnMoveCentralMap(newPosition));
          },
          onCameraIdle: () {
            print('onCameraIdle');
          },
        );
      },
    );
  }
}
