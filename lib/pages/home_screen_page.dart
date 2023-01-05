import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:footer/footer.dart';
import 'package:jira_mobile/models/account_info.dart';
import 'package:jira_mobile/objects/project.dart';
import 'package:jira_mobile/pages/create_project_page.dart';
import 'package:jira_mobile/pages/project_backlog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jira_mobile/networks/project_request.dart';

import '../values/share_keys.dart';

class HomeScreen extends StatefulWidget {
  // truyen vo AccountInfo roi doc database lay cac project ma account nay la leader + member add vao _projects
  final String userId;
  const HomeScreen({super.key, required this.userId});

  //const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() {
    return _HomeScreenPage();
  }
}

class _HomeScreenPage extends State<HomeScreen> with WidgetsBindingObserver {
  // AccountInfo _accountInfo =
  //     AccountInfo(accountId: '', userName: '', password: '');
  // String? accountId = '';
  // // Project _project = Project(name: '', key: '');
  // List<Project> _projects = [
  //   // Project(name: 'huy1', key: 'huyhuy'),
  //   // Project(name: 'huy2', key: 'huyhuy'),
  //   // Project(name: 'huy3', key: 'huyhuy'),
  //   // Project(name: 'huy4', key: 'huyhuy'),
  //   // Project(name: 'huy5', key: 'huyhuy'),
  //   // Project(name: 'huy6', key: 'huyhuy'),
  //   // Project(name: 'huy7', key: 'huyhuy'),
  //   // Project(name: 'huy8', key: 'huyhuy'),
  //   // Project(name: 'huy9', key: 'huyhuy'),
  //   // Project(name: 'huy10', key: 'huyhuy'),
  //   // Project(name: 'huy11', key: 'huyhuy'),
  //   // Project(name: 'huy12', key: 'huyhuy')
  // ];

  List<ProjectModel> projects = [];

  Future<List<ProjectModel>> loadData() async {
    return await getProjectData();
  }
  
  Future<List<ProjectModel>> getProjectData() async {
    List<ProjectModel> res = [];
    res = await RequestData.getMyProjects(userId);
    return res;
  }

  PageController pageController = PageController();

  @override
  void initState() {
    // pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    List<Widget> buildProjectsList() {
      // loadData();
      return projects.map((eachProject) {
        return Card(
            shape: RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(10),
                ),
            elevation: 5,
            child: InkWell(
                onTap: () {
                  // next: detail_project_page, input eachProject
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black, width: 1))),
                  child: ListTile(
                    leading: const Icon(
                        CommunityMaterialIcons.notebook_edit_outline,
                        size: 40,
                        color: Colors.black),
                    title: Text(
                      eachProject.getName.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      eachProject.getKey.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w100,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )));
      }).toList();
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Project',
            style: TextStyle(
                fontSize: 30, color: Colors.black, fontWeight: FontWeight.w800),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                CommunityMaterialIcons.plus,
                size: 30,
                color: Colors.black,
              ),
              // create project
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateProject(
                              userId: userId,
                              projects: projects,
                            )));
              },
            ),
            IconButton(
              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
              icon: Icon(
                CommunityMaterialIcons.account_circle_outline,
                size: 30,
                color: Colors.black,
              ),
              // profile
              onPressed: () {},
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  // account's project
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 30, 0, 30),
                        child: Text(
                          "All projects",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
          
                      // show all project
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          // height of list view
                          height: screenHeight - 250,

                          child: FutureBuilder<List<ProjectModel>>(
                            future: loadData(),
                            builder: (BuildContext context, 
                                AsyncSnapshot<List<ProjectModel>> snapshot) {
                              List<Widget> children;
                              if (snapshot.hasData) {
                                print('has data');
                                projects = snapshot.data!;
                                children = buildProjectsList();
                              }
                              else if (snapshot.hasError) {
                                print('error data');
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
                              }
                              else {
                                print('load data');
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
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: children,
                                ),
                              );
                            },            
                          ),
                      )
                    ],
                  )),
                ])),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      width: 0.5, color: Color.fromARGB(255, 116, 116, 116)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.vertical,
                children: [
                  IconButton(
                    icon: Icon(
                      CommunityMaterialIcons.home_outline,
                      size: 30,
                      color: Colors.black
                    ),
                    onPressed: () {},
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: Text('Home',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          )))
                ],
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.vertical,
                children: [
                  IconButton(
                    icon: Icon(
                      CommunityMaterialIcons.bell_ring_outline,
                      size: 30,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // notifications_page
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: Text('Notifications',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          )))
                ],
              ),
            ],
          ),
        )));
  }
}
