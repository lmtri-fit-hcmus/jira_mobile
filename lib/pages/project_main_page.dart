import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jira_mobile/objects/epic.dart';
import 'package:jira_mobile/pages/create_epic_page.dart';
import 'package:jira_mobile/pages/project_settings_view.dart';
import 'package:jira_mobile/pages/roadmap_view.dart';


class ProjectMainPageWidget extends StatefulWidget {
  const ProjectMainPageWidget({super.key});

  @override
  _ProjectMainPageWidgetState createState() => _ProjectMainPageWidgetState();
}

class _ProjectMainPageWidgetState extends State<ProjectMainPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // index of the views in IndexedStack
  static const int board_view_idx = 0;
  static const int backlog_view_idx = 1;
  static const int roadmap_view_idx = 2;
  static const int settings_view_idx = 3;

  int view_idx = _ProjectMainPageWidgetState.roadmap_view_idx;

  // setting up popup menu button
  static const int roadmap_create_ItemValue = 0;
  static const int roadmap_viewmode_ItemValue = 1;
  static const int roadmap_unit_ItemValue = 2;
  static const int board_create_ItemValue = 3;
  static const int board_share_ItemValue = 4;
  static const int backlog_create_ItemValue = 5;
  static const int backlog_collapse_ItemValue = 6;
  static const int backlog_share_ItemValue = 7;

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
  @override
  Widget build(BuildContext context) {
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
          'Project_name',
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateEpicPageWidget()));
                    break;
                  case roadmap_viewmode_ItemValue:
                    print('switch view mode');
                    break;
                  case roadmap_unit_ItemValue:
                    print('switch unit');
                    break;
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
                      SettingsViewWidget(),
                      RoadmapViewWidget(),
                      RoadmapViewWidget(),// idx = 0      BOARD VIEW HERE
                      // RoadmapViewWidget(epic_list: [
                      //   Epic('A01', 'P01', 'Epic 1', 'Description 1', 'To do', 'U01', 'U01', '01/01/2022', '02/01/2022'),
                      //   Epic('A02', 'P02', 'Epic 2', 'Description 1', 'To do', 'U01', 'U01', '01/01/2022', '02/01/2022'),
                      //   Epic('A03', 'P03', 'Epic 3', 'Description 1', 'To do', 'U01', 'U01', '01/01/2022', '02/01/2022'),
                      //   Epic('A04', 'P04', 'Epic 4', 'Description 1', 'To do', 'U01', 'U01', '01/01/2022', '02/01/2022'),
                      //   Epic('A05', 'P05', 'Epic 5', 'Description 1', 'To do', 'U01', 'U01', '01/01/2022', '02/01/2022'),
                      //   Epic('A06', 'P06', 'Epic 6', 'Description 1', 'To do', 'U01', 'U01', '01/01/2022', '02/01/2022'),
                      //   Epic('A07', 'P07', 'Epic 7', 'Description 1', 'To do', 'U01', 'U01', '01/01/2022', '02/01/2022')
                      // ]),    // idx = 1      BACKLOG VIEW HERE
                      // RoadmapViewWidget(epic_list: [
                      //   Epic('A01', 'P01', 'Epic 1', 'Description 1', 'To do', 'U01', 'U01', '01/01/2022', '02/01/2022'),
                      //   Epic('A02', 'P02', 'Epic 2', 'Description 1', 'To do', 'U01', 'U01', '01/01/2022', '02/01/2022'),
                      //   Epic('A03', 'P03', 'Epic 3', 'Description 1', 'To do', 'U01', 'U01', '01/01/2022', '02/01/2022'),
                      //   Epic('A04', 'P04', 'Epic 4', 'Description 1', 'To do', 'U01', 'U01', '01/01/2022', '02/01/2022'),
                      //   Epic('A05', 'P05', 'Epic 5', 'Description 1', 'To do', 'U01', 'U01', '01/01/2022', '02/01/2022'),
                      //   Epic('A06', 'P06', 'Epic 6', 'Description 1', 'To do', 'U01', 'U01', '01/01/2022', '02/01/2022'),
                      //   Epic('A07', 'P07', 'Epic 7', 'Description 1', 'To do', 'U01', 'U01', '01/01/2022', '02/01/2022')
                      // ]),    // idx = 2
                      SettingsViewWidget()    // idx = 3
                    ],
                  //),
                ),
              ),
              // Divider(
              //   thickness: 1,
              // ),
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Column(
              //       mainAxisSize: MainAxisSize.max,
              //       children: [
              //         IconButton(
              //           icon: Icon(
              //             Icons.home,
              //             color: Colors.black,
              //             size: 22,
              //           ),
              //           onPressed: () {
              //             print('IconButton pressed ...');
              //           },
              //         ),
              //         Text(
              //           'Home',
              //           style: TextStyle(
              //             fontFamily: 'Poppins',
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ],
              //     ),
              //     Column(
              //       mainAxisSize: MainAxisSize.max,
              //       children: [
              //         IconButton(
              //           icon: Icon(
              //             Icons.notifications,
              //             color: Colors.black,
              //             size: 30,
              //           ),
              //           onPressed: () {
              //             print('IconButton pressed ...');
              //           },
              //         ),
              //         Text(
              //           'Notifications',
              //           style: TextStyle(
              //             fontFamily: 'Poppins',
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
