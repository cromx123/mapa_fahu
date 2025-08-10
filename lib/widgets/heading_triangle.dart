import 'package:flutter/material.dart';

class UsachinHeadingMarker extends StatelessWidget {
  final Size size;
  final Color outline;
  final double outlineWidth;

  
  final Color mane;      
  final Color fur;       
  final Color furDark;   
  final Color suit;      
  final Color glove;     
  final Color nose;      
  final Color eye;       
  final Color glassRim;  
  final Color glassFill; 

  const UsachinHeadingMarker({
    super.key,
    this.size = const Size(40, 40),
    this.outline = Colors.white,
    this.outlineWidth = 2,
    this.mane      = const Color(0xFF5D381E),
    this.fur       = const Color(0xFFF2D1A8),
    this.furDark   = const Color(0xFFD9A16F),
    this.suit      = const Color(0xFF8C5431),
    this.glove     = const Color(0xFFEED7B8),
    this.nose      = const Color(0xFF2F2218),
    this.eye       = const Color(0xFF1B1A19),
    this.glassRim  = const Color(0xFF1E88E5),
    this.glassFill = const Color(0x331E88E5),
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: size,
        painter: _UsachinPainter(
          outline: outline,
          outlineWidth: outlineWidth,
          mane: mane,
          fur: fur,
          furDark: furDark,
          suit: suit,
          glove: glove,
          nose: nose,
          eye: eye,
          glassRim: glassRim,
          glassFill: glassFill,
        ),
      ),
    );
  }
}

class _UsachinPainter extends CustomPainter {
  final Color outline;
  final double outlineWidth;
  final Color mane, fur, furDark, suit, glove, nose, eye, glassRim, glassFill;

  _UsachinPainter({
    required this.outline,
    required this.outlineWidth,
    required this.mane,
    required this.fur,
    required this.furDark,
    required this.suit,
    required this.glove,
    required this.nose,
    required this.eye,
    required this.glassRim,
    required this.glassFill,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final shortest = size.width < size.height ? size.width : size.height;
    final scale = shortest / 100.0;
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale, scale);
    canvas.translate(-50, -50);

    final fill = Paint()..style = PaintingStyle.fill..isAntiAlias = true;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = outlineWidth / scale
      ..color = outline
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    
    fill.color = Colors.black12;
    canvas.drawOval(Rect.fromCenter(center: const Offset(50, 92), width: 42, height: 10), fill);
    fill.color = suit;
    final torso = RRect.fromRectAndRadius(
      const Rect.fromLTWH(32, 52, 36, 34),
      const Radius.circular(10),
    );
    canvas.drawRRect(torso, fill);
    canvas.drawRRect(torso, stroke);
    fill.color = fur;
    final belly = RRect.fromRectAndRadius(
      const Rect.fromLTWH(38, 58, 24, 24),
      const Radius.circular(8),
    );
    canvas.drawRRect(belly, fill);

    fill.color = suit;
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(35, 78, 14, 14), const Radius.circular(6)),
      fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(51, 78, 14, 14), const Radius.circular(6)),
      fill,
    );

    final hair = Path()
      ..moveTo(24, 40)
      ..cubicTo(20, 28, 38, 12, 50, 10)
      ..cubicTo(64, 10, 80, 22, 76, 38)
      ..cubicTo(82, 50, 70, 62, 58, 58)
      ..cubicTo(54, 63, 43, 65, 36, 58)
      ..cubicTo(24, 62, 20, 52, 24, 40)
      ..close();
    fill.color = mane;
    canvas.drawPath(hair, fill);
    canvas.drawPath(hair, stroke);

   
    fill.color = fur;
    final head = RRect.fromRectAndRadius(
      const Rect.fromLTWH(30, 22, 40, 28),
      const Radius.circular(14),
    );
    canvas.drawRRect(head, fill);
    canvas.drawRRect(head, stroke);

    final earOuter = Path()..addOval(const Rect.fromLTWH(26, 32, 12, 10));
    fill.color = mane;
    canvas.drawPath(earOuter, fill);
    fill.color = furDark;
    canvas.drawOval(const Rect.fromLTWH(28, 34, 8, 6), fill);

    fill.color = furDark;
    final snout = RRect.fromRectAndRadius(
      const Rect.fromLTWH(40, 32, 24, 16),
      const Radius.circular(8),
    );
    canvas.drawRRect(snout, fill);

    fill.color = nose;
    canvas.drawOval(const Rect.fromLTWH(49, 34, 12, 10), fill);

    final mouthPaint = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(46, 44, 18, 6), const Radius.circular(3)),
      mouthPaint,
    );

    fill.color = eye;
    canvas.drawOval(const Rect.fromLTWH(44, 30, 3.2, 2.8), fill);
    canvas.drawOval(const Rect.fromLTWH(54, 30, 3.2, 2.8), fill);
    fill.color = Colors.white70;
    canvas.drawOval(const Rect.fromLTWH(44.5, 30.2, 0.8, 0.8), fill);
    canvas.drawOval(const Rect.fromLTWH(54.5, 30.2, 0.8, 0.8), fill);

    final browPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = Colors.black26;
    canvas.drawLine(const Offset(42, 28.5), const Offset(48, 28.0), browPaint);
    canvas.drawLine(const Offset(52, 28.5), const Offset(58, 28.0), browPaint);

    fill.color = suit;
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(26, 56, 10, 18), const Radius.circular(5)),
      fill,
    );
    fill.color = glove;
    canvas.drawOval(const Rect.fromLTWH(24, 70, 14, 10), fill);
    final armR = Path()
      ..moveTo(60, 56)
      ..quadraticBezierTo(70, 46, 74, 32)
      ..quadraticBezierTo(70, 46, 58, 56)
      ..close();
    fill.color = suit;
    canvas.drawPath(armR, fill);

    fill.color = glove;
    final rightHand = Rect.fromCenter(
      center: const Offset(74, 30),
      width: 14,
      height: 10,
    );
    canvas.drawOval(rightHand, fill);

    final tail = Path()
      ..moveTo(34, 78)
      ..cubicTo(28, 74, 24, 68, 26, 62)
      ..cubicTo(32, 68, 36, 74, 34, 78)
      ..close();
    fill.color = mane;
    canvas.drawPath(tail, fill);

    final glassCenter = const Offset(76, 20);
    final rimRadius = 12.0;
    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..color = glassRim
      ..isAntiAlias = true;
    canvas.drawCircle(glassCenter, rimRadius, rimPaint);
    canvas.drawCircle(
      glassCenter,
      rimRadius - 2.5,
      Paint()..color = glassFill,
    );

    final handlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = glassRim;
    canvas.drawLine(const Offset(73.0, 30), const Offset(64, 42), handlePaint);
    canvas.drawRRect(torso, stroke);
    canvas.drawRRect(head, stroke);
    canvas.drawPath(hair, stroke);
  }

  @override
  bool shouldRepaint(covariant _UsachinPainter old) {
    return outline != old.outline ||
        outlineWidth != old.outlineWidth ||
        mane != old.mane ||
        fur != old.fur ||
        furDark != old.furDark ||
        suit != old.suit ||
        glove != old.glove ||
        nose != old.nose ||
        eye != old.eye ||
        glassRim != old.glassRim ||
        glassFill != old.glassFill;
  }
}
