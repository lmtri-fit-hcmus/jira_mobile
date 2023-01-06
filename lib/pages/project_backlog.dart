import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jira_mobile/objects/project.dart';
import 'package:jira_mobile/objects/sprint.dart';
import 'package:jira_mobile/objects/issue.dart';
import 'package:jira_mobile/networks/project_request.dart';
import 'package:jira_mobile/pages/issue_page.dart';

import '../values/share_keys.dart';

const userId = "63a185f5205dbf518ca4ab52";

class BacklogTab extends StatefulWidget {
  const BacklogTab({super.key});

  @override
  State<BacklogTab> createState() => _BacklogTabBuilder();
}

class _BacklogTabBuilder extends State<BacklogTab> {
  Map<String, Icon> iconFor = {
    'task': const Icon(Icons.task),
    'bug': const Icon(Icons.bug_report),
    'story': const Icon(Icons.amp_stories_rounded),
    '': const Icon(Icons.assignment_ind_outlined),
  };
  List<String> actionForActive = ["Complete sprint", "Delete sprint"];
  List<String> actionForInactive = ["Start sprint", "Delete sprint"];

  Map<SprintModel, List<IssueModel>> issueOfSprint =
      <SprintModel, List<IssueModel>>{};

  List<ProjectModel> lsPrj = [];
  List<SprintModel> lsSprint = [];

  Future<Map<SprintModel, List<IssueModel>>> loadData() async {
    await getProjectData();

    await getSprintData();

    return await getIssueData();
  }

  getProjectData() async {
    lsPrj = await RequestData.getMyProjects(userId);
  }

  getSprintData() async {
    for (var prj in lsPrj) {
      List<SprintModel> res =
          await RequestData.getMySprint(prj.getId!.toHexString());
      lsSprint += res;
    }
  }

  getIssueData() async {
    List<List<String>> tmpId = [];
    Map<SprintModel, List<IssueModel>> tmpIssueOfSprint =
        <SprintModel, List<IssueModel>>{};

    for (var i = 0; i < lsSprint.length; i++) {
      var spr = lsSprint[i];

      tmpId.add(
          await RequestData.getIssueIdFromSprint(spr.getId!.toHexString()));
      List<IssueModel> lsIss = await RequestData.getMyIssue(tmpId[i]);
      tmpIssueOfSprint[spr] = lsIss;
    }

    return tmpIssueOfSprint;
  }

  List<Widget> buildListTile(List<IssueModel> value, BuildContext context) {
    List<Widget> res = <Widget>[];

    for (var val in value) {
      var type = val.issueType;
      res.add(ListTile(
        title: Text(val.name.toString()),
        leading: iconFor[type],
        trailing: iconFor[""],
        onTap: (() {
          // log(val.getId!.toHexString());
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) {
                  return const IssuePage();
                },
                settings: RouteSettings(arguments: val.getId)),
          );
        }),
      ));
    }

    return res;
  }

  void changeSprint(String cmd, String sprintId) {
    if (cmd.startsWith("Complete") || cmd.startsWith("Start")) {
      RequestData.changeStatusSprint(cmd, sprintId);
    } else if (cmd == "Delete sprint") {
      RequestData.deleteSprint(sprintId);
    }
  }

  List<Widget> buildExpansionTile(BuildContext context) {
    List<Widget> res = <Widget>[];
    _listFuture!.then((value) {
      issueOfSprint = <SprintModel, List<IssueModel>>{};
      issueOfSprint = value;
    });

    issueOfSprint.forEach((key, value) {
      log(key.status.toString());
      List<String> action = (key.status.toString() == "TODO")
          ? actionForInactive
          : actionForActive;
      res.add(ExpansionTile(
        title: Text(key.name.toString()),
        subtitle: Text("${value.length} issue"),
        controlAffinity: ListTileControlAffinity.leading,
        trailing: DropdownButtonHideUnderline(
          child: DropdownButton(
            items: action.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            icon: const Icon(Icons.more_vert),
            onChanged: (value) {
              changeSprint(value.toString(), key.getId!.toHexString());

              setState(() {
                _listFuture = null;
                _listFuture = loadData();
              });
            },
          ),
        ),
        children: buildListTile(value, context),
      ));
    });

    return res;
  }

  Future<Map<SprintModel, List<IssueModel>>>? _listFuture;

  @override
  void initState() {
    super.initState();

    // initial load
    _listFuture = loadData();
  }

  @override
  Widget build(BuildContext context) {
    log("From ==========FutureBuilder: ${issueOfSprint.length.toString()}");

    return SingleChildScrollView(
      child: FutureBuilder<Map<SprintModel, List<IssueModel>>>(
        future: _listFuture,
        builder: (BuildContext context,
            AsyncSnapshot<Map<SprintModel, List<IssueModel>>> snapshot) {
          List<Widget> children;
          log("To ==========FutureBuilder: ${issueOfSprint.length.toString()}");
          if (snapshot.hasData) {
            children = <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildExpansionTile(context),
              ),
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
