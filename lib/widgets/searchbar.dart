part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (BuildContext context, state) {
        if (state.seleccionManual) {
          return Container();
        } else {
          return FadeInDown(
              duration: Duration(milliseconds: 300),
              child: buildSearchBar(context));
        }
      },
    );
  }

  Widget buildSearchBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        width: width,
        child: GestureDetector(
          onTap: () async {
            print('Buscando..');
            final proximidad = context.bloc<MiUbicacionBloc>().state.ubicacion;
            //historial
            final historial = context.bloc<SearchBloc>().state.historial;
            //Resultado de busqueda
            final result = await showSearch(
                context: context,
                delegate: SearchDestination(proximidad, historial));

            returnSearch(context, result);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            width: double.infinity,
            child: Text(
              '¿Donde quieres ir',
              style: TextStyle(color: Colors.black87),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5))
                ]),
          ),
        ),
      ),
    );
  }

  Future returnSearch(BuildContext context, SearchResult result) async {
    print('nombredestino : ${result.nameDestiny}');
    if (result.cancel) {
      return;
    }
    if (result.manual) {
      context.bloc<SearchBloc>().add(OnActivarMarcadorManual());
      return;
    }

    calculandoAlerta(context);
    //Calcular la ruta en base al valor :Result
    final trafficService = new TrafficService();
    final mapaBloc = context.bloc<MapaBloc>();
    final inicio = context.bloc<MiUbicacionBloc>().state.ubicacion;
    final fin = result.position;

    final drivingTraffic =
        await trafficService.getCoordsInicioyFin(inicio, fin);

    final geometry = drivingTraffic.routes[0].geometry;
    final duracion = drivingTraffic.routes[0].duration;
    final distancia = drivingTraffic.routes[0].distance;
    final nameDestiny = result.nameDestiny;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6);
    final List<LatLng> rutaCoordenadas = points.decodedCoords
        .map((points) => LatLng(points[0], points[1]))
        .toList();

    mapaBloc.add(OnCreateRouteDestiny(
        rutaCoordenadas, distancia, duracion, nameDestiny));
    Navigator.pop(context);
    //Agregar historial
    final searchBloc = context.bloc<SearchBloc>();
    searchBloc.add(OnAddHistorial(result));
  }
}
