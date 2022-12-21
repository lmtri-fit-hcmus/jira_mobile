import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../objects/epic.dart';

class RoadmapCard extends StatefulWidget {
  Epic epic;
  RoadmapCard({super.key, required this.epic});
  @override
  State<StatefulWidget> createState() => _RoadmapCardState();
}

class _RoadmapCardState extends State<RoadmapCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {
        print(widget.epic.name);
        // to details page
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
              child: Icon(
                Icons.bolt,
                color: Color(0xFFDA31E4),
                size: 24,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.epic.name,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  //(widget.epic.start_date != null ? widget.epic.start_date! : "") + ' - ' + (widget.epic.due_date != null ? widget.epic.due_date! : ""),
                  "",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
      ),
    );
  }
}
