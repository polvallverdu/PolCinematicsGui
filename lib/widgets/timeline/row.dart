import 'package:flutter/material.dart';
import 'package:polcinematicsgui/widgets/timeline/keyframe.dart';

class TimelineRow extends StatefulWidget {
  final int totalTime;
  final List<Keyframe> keyframes;

  TimelineRow({super.key, required this.totalTime, required this.keyframes});

  @override
  State<TimelineRow> createState() => _TimelineRowState();
}

class _TimelineRowState extends State<TimelineRow> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
