import 'package:flutter/material.dart';

class Keyframe {
  final int time;
  final Color color;

  Keyframe(this.time, this.color);
}

class TimelineWidget extends StatefulWidget {
  final int totalTime;
  final List<Keyframe> keyframes;

  const TimelineWidget(
      {Key? key, required this.totalTime, required this.keyframes})
      : super(key: key);

  @override
  _TimelineWidgetState createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  double _dragStartX = 0.0;
  double _dragCurrentX = 0.0;

  List<Keyframe> _keyframes = [];

  @override
  void initState() {
    super.initState();
    _keyframes = widget.keyframes;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final keyframeRadius = 5.0;

    return GestureDetector(
      onPanStart: (details) {
        _dragStartX = details.localPosition.dx;
      },
      onPanUpdate: (details) {
        setState(() {
          _dragCurrentX = details.localPosition.dx;
        });
      },
      onPanEnd: (details) {
        _dragStartX = 0.0;
        _dragCurrentX = 0.0;
      },
      child: CustomPaint(
        painter: _TimelinePainter(
            widget.totalTime, _keyframes, _dragCurrentX, width, keyframeRadius),
        size: Size(width, 100.0),
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final int totalTime;
  final List<Keyframe> keyframes;
  final double dragPosition;
  final double width;
  final double keyframeRadius;

  _TimelinePainter(this.totalTime, this.keyframes, this.dragPosition,
      this.width, this.keyframeRadius);

  @override
  void paint(Canvas canvas, Size size) {
    final timelinePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0;
    final keyframePaint = Paint();

    // Draw timeline
    final startX = keyframeRadius;
    final endX = width - keyframeRadius;
    final startY = size.height / 2;
    canvas.drawLine(
        Offset(startX, startY), Offset(endX, startY), timelinePaint);

    // Draw keyframes
    for (final keyframe in keyframes) {
      final x = startX + (endX - startX) * (keyframe.time / totalTime);
      final y = startY;

      keyframePaint.color = keyframe.color;
      canvas.drawCircle(Offset(x, y), keyframeRadius, keyframePaint);
    }

    // Draw drag position
    if (dragPosition != 0.0) {
      final x = startX + dragPosition.clamp(0.0, endX - startX);
      final y = startY;

      keyframePaint.color = Colors.white;
      canvas.drawCircle(Offset(x, y), keyframeRadius + 2.0, keyframePaint);
      keyframePaint.color = Colors.black;
      canvas.drawCircle(Offset(x, y), keyframeRadius, keyframePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
