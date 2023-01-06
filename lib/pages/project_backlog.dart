import 'package:flutter/material.dart';
import 'package:jira_mobile/objects/project.dart';
import 'package:jira_mobile/objects/sprint.dart';
import 'package:jira_mobile/objects/issue.dart';
import 'package:jira_mobile/networks/project_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../values/share_keys.dart';


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
  String userId = "";
  List<String> actionForActive = ["Complete sprint", "Edit sprint"];
  List<String> actionForInactive = ["Start sprint", "Edit sprint"];

  Map<SprintModel, List<IssueModel>> issueOfSprint =
      <SprintModel, List<IssueModel>>{};
  List<ProjectModel> lsPrj = [];
  List<SprintModel> lsSprint = [];

  Future<Map<SprintModel, List<IssueModel>>> loadData() async {
    await getProjectData();

    await getSprintData();

    return await getIssueData();
  }
  getAccountId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(AppKey.accountId)??"";
    });
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

  List<Widget> buildListTile(List<IssueModel> value) {
    List<Widget> res = <Widget>[];

    for (var val in value) {
      var type = val.issueType;
      res.add(
        ListTile(
          title: Text(val.name.toString()),
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

    issueOfSprint.forEach((key, value) {
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
              RequestData.changeStatusSprint(
                  value.toString(), key.getId!.toHexString());
              setState(() {
                loadData();
              });
            },
          ),
        ),
        children: buildListTile(value),
      ));
    });

    return res;
  }

  @override
  void initState() {
    super.initState();
    getAccountId();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<Map<SprintModel, List<IssueModel>>>(
        future: loadData(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<SprintModel, List<IssueModel>>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            issueOfSprint = snapshot.data!;
            children = <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buidlExpansionTile(),
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
