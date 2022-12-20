import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:footer/footer.dart';
import 'package:jira_mobile/models/account_info.dart';
import 'package:jira_mobile/objects/project.dart';
import 'package:jira_mobile/pages/create_project_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../values/share_keys.dart';

class HomeScreen extends StatefulWidget {
  // truyen vo AccountInfo roi doc database lay cac project ma account nay la leader + member add vao _projects
  //final AccountInfo accountInfo;
  //const HomeScreen({super.key, required this.accountInfo});

  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() {
    return _HomeScreenPage();
  }
}

class _HomeScreenPage extends State<HomeScreen> with WidgetsBindingObserver {
  AccountInfo _accountInfo =
      AccountInfo(accountId: '', userName: '', password: '');
  String? accountId = '';
  Project _project = Project(name: '', key: '');
  List<Project> _projects = [
    Project(name: 'huy1', key: 'huyhuy'),
    Project(name: 'huy2', key: 'huyhuy'),
    Project(name: 'huy3', key: 'huyhuy'),
    Project(name: 'huy4', key: 'huyhuy'),
    Project(name: 'huy5', key: 'huyhuy'),
    Project(name: 'huy6', key: 'huyhuy'),
    Project(name: 'huy7', key: 'huyhuy'),
    Project(name: 'huy8', key: 'huyhuy'),
    Project(name: 'huy9', key: 'huyhuy'),
    Project(name: 'huy10', key: 'huyhuy'),
    Project(name: 'huy11', key: 'huyhuy'),
    Project(name: 'huy12', key: 'huyhuy')
  ];

  // get list project: leader (User x Project), member (User x Project_Member x Project)
  getProject() {
    // _project =
  }

  x() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      accountId = prefs.getString(AppKey.AccountID);
    });
  }

  @override
  void initState() {
    super.initState();
    // lay projects tu tham so dau vao
    setState(() {
      //_accountInfo = widget.accountInfo;
      getProject();
      x();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    List<Widget> _buildProjectsList() {
      return _projects.map((eachProject) {
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
                      eachProject.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      eachProject.key,
                      style: TextStyle(
                        fontSize: 18,
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
                              accountInfo: _accountInfo,
                              projects: _projects,
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
                        child: ListView(
                          children: _buildProjectsList(),
                        ))
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
                      color: Colors.black,
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
