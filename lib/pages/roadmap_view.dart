import 'package:flutter/material.dart';
import 'package:jira_mobile/custom_widgets/roadmap_card.dart';

import '../objects/epic.dart';


class RoadmapViewWidget extends StatefulWidget {
  // List<Epic> epic_list;
  RoadmapViewWidget({Key? key}) : super(key: key);

  @override
  _RoadmapViewWidgetState createState() => _RoadmapViewWidgetState();
}

class _RoadmapViewWidgetState extends State<RoadmapViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          // children: [
          //   for (var item in widget.epic_list) RoadmapCard(epic: item)
          // ],
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
        )
      )
    );
  }
}
