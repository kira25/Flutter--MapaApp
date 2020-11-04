part of 'custom_markers.dart';

class MarkerDestino extends CustomPainter {
  final String descripcion;
  final double metros;

  MarkerDestino(this.descripcion, this.metros);

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
    path.moveTo(0, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(0, 100);

    canvas.drawShadow(path, Colors.black87, 10, false);

    //caja blanca
    final cajaBlanca = Rect.fromLTWH(0, 20, size.width - 10, 80);
    canvas.drawRect(cajaBlanca, paint);

    //Caja negra
    double kilometros = metros/1000;
    kilometros = (kilometros*100).floor().toDouble();
    kilometros = kilometros/100;
    paint.color = Colors.black;
    final cajaNegra = Rect.fromLTWH(0, 20, 70, 80);
    canvas.drawRect(cajaNegra, paint);

    //Dibujar textos
    TextSpan textSpan = TextSpan(
        text: '$kilometros',
        style: TextStyle(
            color: Colors.green, fontSize: 22, fontWeight: FontWeight.w400));

    TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(0, 35));

    //Minutos
    textSpan = TextSpan(
        text: 'Km',
        style: TextStyle(
            color: Colors.green, fontSize: 20, fontWeight: FontWeight.w400));

    textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70);

    textPainter.paint(canvas, Offset(21, 67));

    //Mi ubicacion
    textSpan = TextSpan(
        text: descripcion,
        style: TextStyle(
            color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400));

    textPainter = TextPainter(
        text: textSpan,
        maxLines: 2,
        ellipsis: '...',
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left)
      ..layout(maxWidth: size.width - 100);

    textPainter.paint(canvas, Offset(90, 40));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
