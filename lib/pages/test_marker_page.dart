import 'package:flutter/material.dart';
import 'package:mapa_app/custom_markers/custom_markers.dart';

class TestMarkerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 150,
          color: Colors.red,
          child: CustomPaint(
            painter: MarkerInicio(250),
            // painter: MarkerDestino(
            //     'descripcion fsdfsdfdsf sdfsdfsdfsdfds sfsdf', 350000),
          ),
        ),
      ),
    );
  }
}
