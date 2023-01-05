import 'package:flutter/material.dart';
import 'package:jira_mobile/objects/project.dart';
import 'package:jira_mobile/objects/sprint.dart';
import 'package:jira_mobile/objects/epic.dart';
import 'package:jira_mobile/objects/issue.dart';
import 'package:jira_mobile/networks/project_request.dart';

const userId = "63a6ccc438cd7617e0e18e6a";

class BoardTab extends StatefulWidget {
  const BoardTab({super.key});

  @override
  State<BoardTab> createState() => _BoardTabBuilder();
}

class _BoardTabBuilder extends State<BoardTab> with TickerProviderStateMixin {
  List<ProjectModel> lsPrj = [];
  List<EpicModel> lsEpic = [];
  List<SprintModel> lsSprint = [];
  List<IssueModel> lsIssue = [];

  Future<List<List<IssueModel>>> createData() async {
    List<List<IssueModel>> res = [];

    List<IssueModel> todo = [];
    List<IssueModel> done = [];
    List<IssueModel> inpr = [];

    for (var s in lsIssue) {
      if (s.status == "TODO") {
        todo.add(s);
      } else if (s.status == "DONE") {
        done.add(s);
      } else {
        inpr.add(s);
      }
    }

    res.add(todo);
    res.add(inpr);
    res.add(done);

    return res;
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

  getEpicData() async {
    for (var prj in lsPrj) {
      List<EpicModel> res =
          await RequestData.getMyEpic(prj.getId!.toHexString());
      lsEpic += res;
    }
  }

  getIssueData() async {
    List<String> tmpId = [];
    for (var spr in lsSprint) {
      tmpId += await RequestData.getIssueIdFromSprint(spr.getId!.toHexString());
    }
    for (var epic in lsEpic) {
      tmpId += await RequestData.getIssueIdFromEpic(epic.getId!.toHexString());
    }
    tmpId = tmpId.toSet().toList();

    lsIssue = await RequestData.getMyIssue(tmpId);
  }

  PageController pageController = PageController();
  TextEditingController textController = TextEditingController();
  List<String> topic = ["TODO", "IN PROGRESS", "DONE"];
  List<List<IssueModel>> data = [];

  int pageIndex = 0;

  Future<List<List<IssueModel>>> loadData() async {
    await getProjectData();
    await getSprintData();
    await getEpicData();
    await getIssueData();
    return await createData();
  }

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    textController = TextEditingController();

    super.initState();
  }

  void submit() {
    Navigator.of(context).pop(textController.text);

    textController.clear();
  }

  List<String> statusValue = ["task", "bug", "story"];
  String dropdownValue = "task";

  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("New Issue"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: "Issue summary"),
            controller: textController,
            onSubmitted: (_) => submit(),
          ),
          actions: [
            StatefulBuilder(
                builder: (BuildContext context, StateSetter dropDownState) {
              return DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                onChanged: (String? value) {
                  dropDownState(() {
                    dropdownValue = value!;
                  });
                },
                items:
                    statusValue.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              );
            }),
            TextButton(onPressed: submit, child: const Text("Submit")),
          ],
        ),
      );

  List<Card> buildListCard(int id) {
    List<Card> res = <Card>[];
    for (var val in data[id]) {
      res.add(
        Card(
          child: ListTile(
            title: Text(
              val.name.toString(),
              style: const TextStyle(fontSize: 15),
            ),
            onTap: () {
              // i.getId == issueId
            },
          ),
        ),
      );
    }
    return res;
  }

  Widget dotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(
        topic.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            onTap: () {
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn);
            },
            child: CircleAvatar(
              radius: 5,
              backgroundColor: pageIndex == index
                  ? const Color.fromARGB(255, 55, 52, 52)
                  : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  String findSprintId() {
    for (var x in lsSprint) {
      if (x.status == "IN PROGRESS") {
        return x.getId!.toHexString();
      }
    }
    return "";
  }

  Widget buildBoardContent() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: PageView.builder(
              controller: pageController,
              // physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: topic.length,
              onPageChanged: (index) {
                setState(() {
                  pageIndex = index;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                final val = topic[index];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: const Color.fromARGB(255, 153, 217, 234),
                        width: double.infinity,
                        margin: const EdgeInsets.all(4),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                val,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            ListView(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              children: buildListCard(index),
                            ),
                            TextButton.icon(
                              style: ElevatedButton.styleFrom(),
                              onPressed: () async {
                                final summary = await openDialog();
                                if (summary == null || summary.isEmpty) {
                                  return;
                                }
                                RequestData.addNewIssue(
                                        summary, dropdownValue, topic[index])
                                    .then((String newIssueId) {
                                  RequestData.addIssueToSprint(
                                      findSprintId(), newIssueId.toString());
                                });
                                setState(() {
                                  loadData();
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                size: 24.0,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'Create',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          dotIndicator(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Size pSize = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.all(Radius.circular(200)),
      ),
      child: FutureBuilder<List<List<IssueModel>>>(
        future: loadData(),
        builder: (BuildContext context,
            AsyncSnapshot<List<List<IssueModel>>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            data = snapshot.data!;
            children = <Widget>[buildBoardContent()];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                  width: 60, height: 60, child: CircularProgressIndicator()),
              Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...')),
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
