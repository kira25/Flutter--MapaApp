part of 'widgets.dart';

class BtnMiRuta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapBloc = context.bloc<MapaBloc>();

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
            icon: Icon(
              Icons.follow_the_signs,
              color: Colors.black87,
            ),
            onPressed: () {
                mapBloc.add(OnPaintRoute());
              
            }),
      ),
    );
  }
}
