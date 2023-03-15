import 'package:flutter/material.dart';
import 'package:polcinematicsgui/widgets/sidebar/selected.dart';
import 'package:polcinematicsgui/widgets/timeline/row.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width * 0.2;
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text("TIMELINE TIME"),
                    width: screen_width,
                  ),
                  Divider(color: Colors.black),
                  Text("TIMELINE NAMES"),
                ],
              ),
              VerticalDivider(color: Colors.black),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text("TIMELINE BAR"),
                  ),
                  Divider(color: Colors.black),
                  Text("TIMELINES"),
                ],
              ),
            ],
          ),
          SidebarWidget(
            selectedData: SelectedData(SelectedType.none),
          ),
        ],
      ),
    );
  }
}
