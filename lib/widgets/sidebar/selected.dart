import 'package:flutter/material.dart';
import 'package:polcinematicsgui/widgets/timeline/keyframe.dart';

enum SelectedType {
  none,
  keyframe,
}

class SelectedData {
  final SelectedType type;

  SelectedData(this.type);
}

class SelectedKeyframeData extends SelectedData {
  final Keyframe keyframe;

  SelectedKeyframeData(this.keyframe) : super(SelectedType.keyframe);
}

class SidebarWidget extends StatelessWidget {
  final SelectedData selectedData;

  const SidebarWidget({super.key, required this.selectedData});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: double.infinity,
      width: screenWidth * 0.2,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Text("Sidebar"),
    );
  }
}
