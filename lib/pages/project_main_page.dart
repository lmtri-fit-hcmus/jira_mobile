import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jira_mobile/custom_widgets/roadmap_card.dart';
import 'package:jira_mobile/objects/appdb.dart';
import 'package:jira_mobile/objects/appinfo.dart';
import 'package:jira_mobile/objects/epic.dart';
import 'package:jira_mobile/pages/create_epic_page.dart';
import 'package:jira_mobile/pages/project_backlog.dart';
import 'package:jira_mobile/pages/project_board.dart';
import 'package:jira_mobile/pages/project_settings_view.dart';
import 'package:jira_mobile/pages/roadmap_view.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongodart;

import '../objects/project.dart' as obj;
import '../objects/user.dart';


class ProjectMainPageWidget extends StatefulWidget {
  const ProjectMainPageWidget({super.key}) ;
  @override
  _ProjectMainPageWidgetState createState() => _ProjectMainPageWidgetState();
}

class _ProjectMainPageWidgetState extends State<ProjectMainPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  User current_user = GetIt.instance<AppInfo>().current_user;
  obj.Project current_project = GetIt.instance<AppInfo>().current_project;
  TextEditingController te1 = TextEditingController();
  TextEditingController te2 = TextEditingController();
  int tmp = 0;



  // index of the views in IndexedStack
  static const int board_view_idx = 0;
  static const int backlog_view_idx = 1;
  static const int roadmap_view_idx = 2;
  static const int settings_view_idx = 3;

  int view_idx = _ProjectMainPageWidgetState.board_view_idx;
  List<Epic> epics = [];

  // setting up popup menu button
  static const int roadmap_create_ItemValue = 0;
  static const int roadmap_viewmode_ItemValue = 1;
  static const int roadmap_unit_ItemValue = 2;
  static const int board_create_ItemValue = 3;
  static const int board_share_ItemValue = 4;
  static const int backlog_create_ItemValue = 5;
  static const int backlog_collapse_ItemValue = 6;
  static const int backlog_share_ItemValue = 7;

  void add(Epic epic) {
    setState(() {
      epics.add(epic);
    });
  }

  void renew_project() {
    setState(() {
      current_project = GetIt.instance<AppInfo>().current_project;
    });
    // continue to refresh projects page
  }

  final PopupMenuItemBuilder<int> roadmap_MenuItemBuilder = (BuildContext context) => <PopupMenuEntry<int>> [
    const PopupMenuItem(
        child: Text('Create epic',
          style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.normal
          ),
        ),
        value: _ProjectMainPageWidgetState.roadmap_create_ItemValue,
    ),
    const PopupMenuItem(
        child: Text('View as list',
          style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.normal
          ),
        ),
      value: _ProjectMainPageWidgetState.roadmap_viewmode_ItemValue,
    ),
    const PopupMenuItem(
        child: Text('Mode',
          style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.normal
          ),
        ),
      value: _ProjectMainPageWidgetState.roadmap_unit_ItemValue,
    )
  ];
  final PopupMenuItemBuilder<int> backlog_MenuItemBuilder = (BuildContext context) => <PopupMenuEntry<int>> [
    const PopupMenuItem(
      child: Text('Create sprint',
        style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.normal
        ),
      ),
      value: backlog_create_ItemValue,
    ),
    const PopupMenuItem(
      child: Text('Collapse all sprints',
        style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.normal
        ),
      ),
      value: backlog_collapse_ItemValue,
    ),
    const PopupMenuItem(
      child: Text('Share',
        style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.normal
        ),
      ),
      value: backlog_share_ItemValue,
    )
  ];
  final PopupMenuItemBuilder<int> board_MenuItemBuilder = (BuildContext context) => <PopupMenuEntry<int>> [
    const PopupMenuItem(
      child: Text('Add new column',
        style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.normal
        ),
      ),
      value: board_create_ItemValue,
    ),
    const PopupMenuItem(
      child: Text('Share',
        style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.normal
        ),
      ),
      value: board_share_ItemValue,
    )
  ];
  final PopupMenuItemBuilder<int> setting_MenuItemBuilder = (BuildContext context) => <PopupMenuEntry<int>> [];

  Future<List<Epic>> fetchEpics() async {
    var coll = GetIt.instance<AppDB>().main_db.collection('epics');
    var list = await coll.find(mongodart.where.eq('project_id', current_project.id)).toList();
    List<Epic> res = [];
    list.forEach((element) {
      res.add(Epic(element['_id'], element['project_id'], element['name'] ?? '', element['status'] ?? '', element['description'] ?? '', element['assignee'],
          element['reporter'], element['start_date'] != null ? DateTime.tryParse(element['start_date']) : null,
          element['due_date'] != null ? DateTime.tryParse(element['due_date']) : null, []));
    });
    
    return res;
  }

  void createSprint() {
    te1.clear();
    te2.clear();
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Create new sprint'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: te1,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Sprint name',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: te2,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Sprint goal',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
              ),

            )
          ],
        ),
        actions: [
          Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
              child: TextButton(
                  onPressed: () async {
                    var name = te1.text.toString();
                    var goal = te2.text.toString();
                    if (name.length > 0)
                    {
                      var coll = GetIt.instance<AppDB>().main_db.collection("sprints");
                      await coll.insertOne(<String, dynamic> {
                        'project_id' : current_project.id,
                        'name' : name,
                        'goal' : goal,
                        'start_date': '',
                        'due_date' : '',
                        'status' : 'TO DO'
                      }).then((value) => {
                        if (value.isSuccess) {
                          GetIt.instance<AppDB>().main_db.collection('sprint_issue').insertOne(<String, dynamic> {
                            'sprint_id' : value.id,
                            'issues' : []
                          })
                        }
                      });
                    }
                    Navigator.pop(context);
                  },  child: Text('Create'))
          )
        ],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    epics = [];
    fetchEpics().then((value) => value.forEach((element) { setState(() {
      epics.add(element);
    });}));
  }

  @override
  void dispose() {
    super.dispose();
    te1.dispose();
    te2.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    print("Current User: ${current_user.id}");
    print("Current Project: ${current_project.id}");
    print(epics);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.cyanAccent,
            size: 30
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          current_project.name,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.cyanAccent,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
            child: PopupMenuButton<int>(
              icon: Icon(
                Icons.keyboard_control,
                color: (view_idx >= 0 && view_idx <= 2) ? Colors.cyanAccent : Colors.transparent,
                size: 30,
              ),
              offset: Offset(-10, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              itemBuilder: (view_idx == board_view_idx) ? board_MenuItemBuilder :
                          ((view_idx == backlog_view_idx) ? backlog_MenuItemBuilder :
                          ((view_idx == roadmap_view_idx) ? roadmap_MenuItemBuilder :
                          ((view_idx == settings_view_idx) ? setting_MenuItemBuilder : setting_MenuItemBuilder))),
              onSelected: (selected) {
                switch (selected) {
                  case roadmap_create_ItemValue:
                    print('create epic');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateEpicPageWidget(current_user: current_user, current_project: current_project, callback: add)));
                    break;
                  case roadmap_viewmode_ItemValue:
                    print('switch view mode');
                    break;
                  case roadmap_unit_ItemValue:
                    print('switch unit');
                    break;
                  case backlog_create_ItemValue:
                    {
                      createSprint();
                      break;
                    }
                  default:
                    break;
                }
              },
              enabled: (view_idx != settings_view_idx) ? true : false
            ),
          )

        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide (
                          color: Colors.black,
                          width: 3.0,
                          style: (view_idx == board_view_idx) ? BorderStyle.solid : BorderStyle.none
                        )
                      )
                    ),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          view_idx = board_view_idx;
                        });
                      },
                      child: Text(
                        'Board',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: (view_idx == board_view_idx) ? FontWeight.w900 : FontWeight.normal,
                        ),
                      )
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide (
                                color: Colors.black,
                                width: 3.0,
                                style: (view_idx == backlog_view_idx) ? BorderStyle.solid : BorderStyle.none
                            )
                        )
                    ),
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            view_idx = backlog_view_idx;
                          });
                        },
                        child: Text(
                          'Backlog',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: (view_idx == backlog_view_idx) ? FontWeight.w900 : FontWeight.normal,
                          ),
                        )
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide (
                                color: Colors.black,
                                width: 3.0,
                                style: (view_idx == roadmap_view_idx) ? BorderStyle.solid : BorderStyle.none
                            )
                        )
                    ),
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            view_idx = roadmap_view_idx;
                          });
                        },
                        child: Text(
                          'Roadmap',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: (view_idx == roadmap_view_idx) ? FontWeight.w900 : FontWeight.normal,
                          ),
                        )
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide (
                                color: Colors.black,
                                width: 3.0,
                                style: (view_idx == settings_view_idx) ? BorderStyle.solid : BorderStyle.none
                            )
                        )
                    ),
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            view_idx = settings_view_idx;
                          });
                        },
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: (view_idx == settings_view_idx) ? FontWeight.w900 : FontWeight.normal,
                          ),
                        )
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
                color: Colors.black,
              ),
              Expanded(
                //child: InkWell(
                  //onTap: () async {},
                  child: IndexedStack(
                    index: view_idx,
                    children: [
                      BoardTab(userId: current_user.id!.toHexString(), projectId: current_project.id.toHexString()), // idx = 0      BOARD VIEW HERE
                      BacklogTab(userId: current_user.id!.toHexString(), projectId: current_project.id.toHexString(), tmp: tmp),    // idx = 1      BACKLOG VIEW HERE
                      RoadmapViewWidget(epic_list: epics),    // idx = 2
                      SettingsViewWidget(refresh_callback: renew_project)    // idx = 3
                    ],
                  //),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }




}
