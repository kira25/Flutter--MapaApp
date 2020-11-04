import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AccessGpsPage extends StatefulWidget {
  @override
  _AccessGpsPageState createState() => _AccessGpsPageState();
}

class _AccessGpsPageState extends State<AccessGpsPage>
    with WidgetsBindingObserver {
  bool popup = false;

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
    print('State : $state');
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    //Si regresa con los permisos concedidos a la app , regresar a loading para validacion
    if (state == AppLifecycleState.resumed && !popup) {
      if (await Permission.location.isGranted) {
        Navigator.pushReplacementNamed(context, 'loading');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('AccessGpsPage'),
            MaterialButton(
              onPressed: () async {
                popup = true;
                await accessoGPS();
                popup = false;
              },
              child: Text(
                'Solicitar acceso',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.black,
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  Future accessoGPS() async {
    final status = await Permission.location.request();

    print(status);

    switch (status) {
      case PermissionStatus.granted:
        //
        await Navigator.pushReplacementNamed(context, 'loading');
        break;
      case PermissionStatus.undetermined:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
    }
  }
}
