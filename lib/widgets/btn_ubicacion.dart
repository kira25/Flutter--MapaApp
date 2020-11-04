part of 'widgets.dart';

class BtnUbicacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapBloc = context.bloc<MapaBloc>();
    final miUbicacionBloc = context.bloc<MiUbicacionBloc>();

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
            icon: Icon(
              Icons.my_location,
              color: Colors.black87,
            ),
            onPressed: () {
              final destino = miUbicacionBloc.state.ubicacion;
              mapBloc.moveCamera(destino);
            }),
      ),
    );
  }
}
