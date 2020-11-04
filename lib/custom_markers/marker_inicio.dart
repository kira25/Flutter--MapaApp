part of 'custom_markers.dart';

class MarkerInicio extends CustomPainter {
  final int minutos;

  MarkerInicio(this.minutos);
  @override
  void paint(Canvas canvas, Size size) {
    final double circuloNegroR = 20;
    final double circuloBlancoR = 7;
    Paint paint = new Paint()..color = Colors.black;
    canvas.drawCircle(
        Offset(circuloNegroR, size.height - circuloNegroR), 20, paint);

//circulo blanco
    paint.color = Colors.white;
    canvas.drawCircle(Offset(circuloNegroR, size.height - circuloNegroR),
        circuloBlancoR, paint);

    final path = Path();
    path.moveTo(40, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);

    canvas.drawShadow(path, Colors.black87, 10, false);

    //caja blanca
    final cajaBlanca = Rect.fromLTWH(40, 20, size.width - 55, 80);
    canvas.drawRect(cajaBlanca, paint);

    //Caja negra
    paint.color = Colors.black;
    final cajaNegra = Rect.fromLTWH(40, 20, 70, 80);
    canvas.drawRect(cajaNegra, paint);

    //Dibujar textos
    TextSpan textSpan = TextSpan(
        text: '$minutos',
        style: TextStyle(
            color: Colors.green, fontSize: 30, fontWeight: FontWeight.w400));

    TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(40, 35));

    //Minutos
    textSpan = TextSpan(
        text: 'Min',
        style: TextStyle(
            color: Colors.green, fontSize: 20, fontWeight: FontWeight.w400));

    textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(40, 67));

    //Mi ubicacion
    textSpan = TextSpan(
        text: 'Mi Ubicacion',
        style: TextStyle(
            color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400));

    textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: size.width - 130);

    textPainter.paint(canvas, Offset(160, 50));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
