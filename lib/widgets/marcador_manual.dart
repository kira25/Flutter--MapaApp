part of 'widgets.dart';

class MarcadoManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return _BuildMarcadoManual();
        } else {
          return Container();
        }
      },
    );
  }
}

class _BuildMarcadoManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        //Back button
        Positioned(
            top: 70,
            left: 20,
            child: FadeInLeft(
              duration: Duration(milliseconds: 150),
              child: CircleAvatar(
                maxRadius: 25,
                backgroundColor: Colors.white,
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      context
                          .bloc<SearchBloc>()
                          .add(OnDesactivarMarcadorManual());
                    }),
              ),
            )),

        Center(
          child: Transform.translate(
              offset: Offset(0, -12),
              child: BounceInDown(
                  from: 200, child: Icon(Icons.location_on, size: 50))),
        ),
        Positioned(
            bottom: 70,
            left: 40,
            child: FadeIn(
              child: MaterialButton(
                  shape: StadiumBorder(),
                  elevation: 0,
                  splashColor: Colors.transparent,
                  color: Colors.black,
                  child: Text('Confirm destiny',
                      style: TextStyle(color: Colors.white)),
                  minWidth: width - 120,
                  onPressed: () {
                    calcularDestino(context);
                  }),
            )),
      ],
    );
  }

  void calcularDestino(BuildContext context) async {
    calculandoAlerta(context);
    final trafficService = new TrafficService();

    final mapaBloc = context.bloc<MapaBloc>();
    //Extraccion del inicio y fin
    final inicio = context.bloc<MiUbicacionBloc>().state.ubicacion;
    final fin = mapaBloc.state.ubicacionCentral;

    //Obtener informacion del destino
    final reverseQueryResponse = await trafficService.getCoordenadasInfo(fin);

    final drivingResponse =
        await trafficService.getCoordsInicioyFin(inicio, fin);
    //La primera sugerencia de ruta
    final geometry = drivingResponse.routes[0].geometry;
    final duracion = drivingResponse.routes[0].duration;
    final distancia = drivingResponse.routes[0].distance;
    final nameDestiny = reverseQueryResponse.features[0].text;
    final description = reverseQueryResponse.features[0].placeName;

    //Decodificar los puntos del geometry
    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;
    final List<LatLng> coordsList =
        points.map((e) => LatLng(e[0], e[1])).toList();
    //Creacion de la ruta por medio del marcador manual
    mapaBloc.add(
        OnCreateRouteDestiny(coordsList, distancia, duracion, nameDestiny));

    //Agregar historial
    final searchBloc = context.bloc<SearchBloc>();
    //Mapbox ( latitude , longitude)
    final result = SearchResult(
        cancel: false,
        manual: false,
        position: LatLng(fin.latitude, fin.longitude),
        nameDestiny: nameDestiny,
        description: description);

    searchBloc.add(OnAddHistorial(result));

    Navigator.pop(context);

    //Tarea: quitar el confirmar destino, marcador y el boton para regresar
    context.bloc<SearchBloc>().add(OnDesactivarMarcadorManual());
  }
}
