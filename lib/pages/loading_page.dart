import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapa_app/helpers/helpers.dart';
import 'package:mapa_app/pages/access_gps_page.dart';
import 'package:mapa_app/pages/mapa_page.dart';
import 'package:permission_handler/permission_handler.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (await Geolocator.isLocationServiceEnabled()) {
        Navigator.pushReplacement(
            context, navigateMapFadein(context, MapaPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: checkGps(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Text(snapshot.data),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            }
          }),
    );
  }

  Future checkGps(BuildContext context) async {
    //TODO: permiso GPS para la app
    final permissionGPS = await Permission.location.isGranted;
    //TODO: GPS esta activo del mobile
    final gpsActive = await Geolocator.isLocationServiceEnabled();

    if (permissionGPS && gpsActive) {
      Navigator.pushReplacement(
          context, navigateMapFadein(context, MapaPage()));
      return '';
    } else if (!permissionGPS) {
      Navigator.pushReplacement(
          context, navigateMapFadein(context, AccessGpsPage()));
      return 'Mapa app GPS is required';
    } else {
      return 'Active el GPS';
    }

  
  }
}
