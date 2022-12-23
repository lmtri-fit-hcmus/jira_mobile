import 'package:flutter/material.dart';

class BacklogTab extends StatefulWidget {
  const BacklogTab({super.key});

  @override
  State<BacklogTab> createState() => _BacklogTabBuilder();
}

class _BacklogTabBuilder extends State<BacklogTab> {
  List<String> name = ["Sprint 1", "Sprint 2", "Sprint 3"];
  List<String> status = ["active", "unactive", "active"];
  List<List<String>> data = [
    ["Task 1.1", "Task 1.2", "Bug 1", "Story 1"],
    ["Task 2", "Bug 2"],
    [
      "Task 3.1",
      "Task 3.2",
      "Bug 3",
      "Bug 3.1",
      "Bug 3.2",
      "Story 3.1",
      "Story 3.2",
      "Story 3.3"
    ]
  ];
  Map<String, Icon> iconFor = {
    'Task': const Icon(Icons.task),
    'Bug': const Icon(Icons.bug_report),
    'Story': const Icon(Icons.amp_stories_rounded),
    '': const Icon(Icons.assignment_ind_outlined),
  };

  List<Widget> buildListTile(int id) {
    List<Widget> res = <Widget>[];

    for (var val in data[id]) {
      var type = val.split(" ")[0];
      res.add(
        ListTile(
          title: Text(val),
          leading: iconFor[type],
          trailing: iconFor[""],
          // onTap: null,
        ),
      );
    }

    return res;
  }

  List<Widget> buidlExpansionTile() {
    List<Widget> res = <Widget>[];

    for (var i = 0; i < 3; i++) {
      res.add(ExpansionTile(
        title: Text(name[i]),
        subtitle: Text("${data[i].length} issue"),
        controlAffinity: ListTileControlAffinity.leading,
        children: buildListTile(i),
      ));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buidlExpansionTile(),
      ),
    );
  }
}
