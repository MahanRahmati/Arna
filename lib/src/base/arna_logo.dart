import 'package:arna/arna.dart';

// Made with https://fluttershapemaker.com/ :)

/// The Arna logo, in widget form.
class ArnaLogo extends StatelessWidget {
  /// Creates a widget that paints the Arna logo.
  ///
  /// The [size] defaults to the [Styles.iconSize].
  const ArnaLogo({
    super.key,
    this.size = Styles.iconSize,
  });

  /// The size of the logo in logical pixels.
  ///
  /// The logo will be fit into a square this size.
  final double size;

  @override
  Widget build(final BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: ArnaLogoPainter(),
    );
  }
}

/// The Arna logo painter.
class ArnaLogoPainter extends CustomPainter {
  @override
  void paint(final Canvas canvas, final Size size) {
    final Path path_0 = Path();
    path_0.moveTo(size.width * 0.5000000, size.height * 0.1708750);
    path_0.lineTo(size.width * 0.5000000, size.height * 0.8293229);
    path_0.arcToPoint(
      Offset(size.width * 0.5463880, size.height * 0.8183646),
      radius: Radius.elliptical(
        size.width * 0.1036754,
        size.height * 0.1036754,
      ),
      clockwise: false,
    );
    path_0.lineTo(size.width * 0.7364557, size.height * 0.7232734);
    path_0.arcToPoint(
      Offset(size.width * 0.7595026, size.height * 0.6537422),
      radius: Radius.elliptical(
        size.width * 0.05172245,
        size.height * 0.05172245,
      ),
      clockwise: false,
    );
    path_0.lineTo(size.width * 0.5233412, size.height * 0.1850521);
    path_0.arcToPoint(
      Offset(size.width * 0.5000000, size.height * 0.1708750),
      radius: Radius.elliptical(
        size.width * 0.02613605,
        size.height * 0.02613605,
      ),
      clockwise: false,
    );
    path_0.close();

    final Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff1fbcfd);
    canvas.drawPath(path_0, paint0Fill);

    final Path path_1 = Path();
    path_1.moveTo(size.width * 0.5000000, size.height * 0.1708750);
    path_1.arcToPoint(
      Offset(size.width * 0.4766589, size.height * 0.1850521),
      radius: Radius.elliptical(
        size.width * 0.02613605,
        size.height * 0.02613605,
      ),
      clockwise: false,
    );
    path_1.lineTo(size.width * 0.2404974, size.height * 0.6537422);
    path_1.arcToPoint(
      Offset(size.width * 0.2635443, size.height * 0.7232734),
      radius: Radius.elliptical(
        size.width * 0.05172245,
        size.height * 0.05172245,
      ),
      clockwise: false,
    );
    path_1.lineTo(size.width * 0.4536120, size.height * 0.8183646);
    path_1.arcToPoint(
      Offset(size.width * 0.5000000, size.height * 0.8293229),
      radius: Radius.elliptical(
        size.width * 0.1036754,
        size.height * 0.1036754,
      ),
      clockwise: false,
    );
    path_1.close();

    final Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = const Color(0xff44d1fd);
    canvas.drawPath(path_1, paint1Fill);

    final Path path_2 = Path();
    path_2.moveTo(size.width * 0.2476380, size.height * 0.6395677);
    path_2.lineTo(size.width * 0.2404974, size.height * 0.6537422);
    path_2.arcToPoint(
      Offset(size.width * 0.2635443, size.height * 0.7232734),
      radius: Radius.elliptical(
        size.width * 0.05172245,
        size.height * 0.05172245,
      ),
      clockwise: false,
    );
    path_2.lineTo(size.width * 0.4536120, size.height * 0.8183646);
    path_2.arcToPoint(
      Offset(size.width * 0.5000000, size.height * 0.8293229),
      radius: Radius.elliptical(
        size.width * 0.1036754,
        size.height * 0.1036754,
      ),
      clockwise: false,
    );
    path_2.arcToPoint(
      Offset(size.width * 0.5463880, size.height * 0.8183646),
      radius: Radius.elliptical(
        size.width * 0.1036754,
        size.height * 0.1036754,
      ),
      clockwise: false,
    );
    path_2.lineTo(size.width * 0.7364557, size.height * 0.7232734);
    path_2.arcToPoint(
      Offset(size.width * 0.7595026, size.height * 0.6537422),
      radius: Radius.elliptical(
        size.width * 0.05172245,
        size.height * 0.05172245,
      ),
      clockwise: false,
    );
    path_2.lineTo(size.width * 0.7524245, size.height * 0.6396927);
    path_2.arcToPoint(
      Offset(size.width * 0.7513776, size.height * 0.6409010),
      radius: Radius.elliptical(
        size.width * 0.05172245,
        size.height * 0.05172245,
      ),
    );
    path_2.arcToPoint(
      Offset(size.width * 0.7491901, size.height * 0.6431380),
      radius: Radius.elliptical(
        size.width * 0.05172245,
        size.height * 0.05172245,
      ),
    );
    path_2.arcToPoint(
      Offset(size.width * 0.7468698, size.height * 0.6452396),
      radius: Radius.elliptical(
        size.width * 0.05172245,
        size.height * 0.05172245,
      ),
    );
    path_2.arcToPoint(
      Offset(size.width * 0.7444271, size.height * 0.6471979),
      radius: Radius.elliptical(
        size.width * 0.05172245,
        size.height * 0.05172245,
      ),
    );
    path_2.arcToPoint(
      Offset(size.width * 0.7418724, size.height * 0.6490052),
      radius: Radius.elliptical(
        size.width * 0.05172245,
        size.height * 0.05172245,
      ),
    );
    path_2.arcToPoint(
      Offset(size.width * 0.7392109, size.height * 0.6506536),
      radius: Radius.elliptical(
        size.width * 0.05172245,
        size.height * 0.05172245,
      ),
    );
    path_2.arcToPoint(
      Offset(size.width * 0.7364557, size.height * 0.6521380),
      radius: Radius.elliptical(
        size.width * 0.05172245,
        size.height * 0.05172245,
      ),
    );
    path_2.lineTo(size.width * 0.5463880, size.height * 0.7472292);
    path_2.arcToPoint(
      Offset(size.width * 0.5353463, size.height * 0.7519739),
      radius: Radius.elliptical(
        size.width * 0.1036754,
        size.height * 0.1036754,
      ),
    );
    path_2.arcToPoint(
      Offset(size.width * 0.5238333, size.height * 0.7554115),
      radius: Radius.elliptical(
        size.width * 0.1036754,
        size.height * 0.1036754,
      ),
    );
    path_2.arcToPoint(
      Offset(size.width * 0.5119974, size.height * 0.7574896),
      radius: Radius.elliptical(
        size.width * 0.1036754,
        size.height * 0.1036754,
      ),
    );
    path_2.arcToPoint(
      Offset(size.width * 0.5000000, size.height * 0.7581875),
      radius: Radius.elliptical(
        size.width * 0.1036754,
        size.height * 0.1036754,
      ),
    );
    path_2.arcToPoint(
      Offset(size.width * 0.4880026, size.height * 0.7574896),
      radius: Radius.elliptical(
        size.width * 0.1036754,
        size.height * 0.1036754,
      ),
    );
    path_2.arcToPoint(
      Offset(size.width * 0.4761667, size.height * 0.7554115),
      radius: Radius.elliptical(
        size.width * 0.1036754,
        size.height * 0.1036754,
      ),
    );
    path_2.arcToPoint(
      Offset(size.width * 0.4646536, size.height * 0.7519739),
      radius: Radius.elliptical(
        size.width * 0.1036754,
        size.height * 0.1036754,
      ),
    );
    path_2.arcToPoint(
      Offset(size.width * 0.4536120, size.height * 0.7472292),
      radius: Radius.elliptical(
        size.width * 0.1036754,
        size.height * 0.1036754,
      ),
    );
    path_2.lineTo(size.width * 0.2635443, size.height * 0.6521380);
    path_2.arcToPoint(
      Offset(size.width * 0.2558516, size.height * 0.6474063),
      radius: Radius.elliptical(
        size.width * 0.05172245,
        size.height * 0.05172245,
      ),
    );
    path_2.arcToPoint(
      Offset(size.width * 0.2490964, size.height * 0.6414089),
      radius: Radius.elliptical(
        size.width * 0.05172245,
        size.height * 0.05172245,
      ),
    );
    path_2.arcToPoint(
      Offset(size.width * 0.2476380, size.height * 0.6395677),
      radius: Radius.elliptical(
        size.width * 0.05172245,
        size.height * 0.05172245,
      ),
    );
    path_2.close();

    final Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = const Color(0xff255698);
    canvas.drawPath(path_2, paint2Fill);
  }

  @override
  bool shouldRepaint(covariant final CustomPainter oldDelegate) => false;
}
