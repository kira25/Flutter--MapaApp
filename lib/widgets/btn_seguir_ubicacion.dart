part of 'widgets.dart';

class BtnSeguirUbicacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
 

    return BlocBuilder<MapaBloc, MapaState>(
        builder: (BuildContext context, state) {
      return followingButton(context,state);
    });
  }

  Container followingButton(BuildContext context,MapaState state) {
       final mapBloc = context.bloc<MapaBloc>();
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
            icon: Icon(
              mapBloc.state.seguirUbicacion
                  ? Icons.directions_run
                  : Icons.accessibility_new,
              color: Colors.black87,
            ),
            onPressed: () {
              mapBloc.add(OnFollowLocation());
            }),
      ),
    );
  }
}
