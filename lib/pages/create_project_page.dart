import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:jira_mobile/custom_widgets/custom_button.dart';
import 'package:jira_mobile/models/account_info.dart';
import 'package:jira_mobile/objects/project.dart';
import 'package:jira_mobile/pages/home_screen_page.dart';

class CreateProject extends StatefulWidget {
  // truyen vao thong tin tai khoan (de gan leader)
  // truyen vao cac projects cua account do de ko tao project trung ten/ trung key
  final AccountInfo accountInfo;
  final List<Project> projects;
  const CreateProject(
      {super.key, required this.accountInfo, required this.projects});

  //const CreateProject({super.key});
  @override
  State<CreateProject> createState() {
    return _CreateProjectPage();
  }
}

class _CreateProjectPage extends State<CreateProject> {
  Project _project = Project(name: '', key: '');
  String _projectName = '';
  String _projectKey = '';
  List<Project> _projects = [];
  String errStr = '';

  // add project in db Project: leader = widget.accountInfo.accountId
  addProject(Project project) {
    // to do
  }

  @override
  void initState() {
    super.initState();
    // lay projects tu tham so dau vao
    setState(() {
      _projects = widget.projects;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    String projectNameExisted = "A project with that name already exists";
    String projectKeyExisted = "This key is already used in another project";

    String projectNameEmpty =
        "Project name is empty. Please enter your project name";
    String projectKeyEmpty =
        "Project key is empty. Please enter your project key";

    // xu li create project
    void _checkNewProject() {
      errStr = '';
      // check empty
      if (_projectName.isEmpty) {
        setState(() {
          errStr = projectNameEmpty;
        });
        return;
      }
      if (_projectKey.isEmpty) {
        setState(() {
          errStr = projectKeyEmpty;
        });
        return;
      }
      // check existed
      int i = 0;
      for (; i < _projects.length; i++) {
        if (_projects[i].name == _projectName) {
          setState(() {
            errStr = projectNameExisted;
          });
          break;
        } else if (_projects[i].key == _projectKey) {
          setState(() {
            errStr = projectKeyExisted;
          });
          break;
        }
      }
      print(errStr);
      // name and key OK
      if (i == _projects.length && errStr == '') {
        // add project for account (leader = accountInfo.ID) and back previous page
        _project.name = _projectName;
        _project.key = _projectKey;
        addProject(_project);
        // next: detail_project_page
        print('create project success');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 30,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
                child: Image.asset(
              'assets/images/create_project.png',
              width: screenWidth,
              height: screenHeight * 0.25,
              fit: BoxFit.cover,
            )),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                'Create project',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 40, 15, 0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _projectName = value;
                  });
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Project name',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _projectKey = value;
                  });
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Project key',
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Text(
                '$errStr',
                style: TextStyle(color: Colors.red),
              ),
            ),
            Container(
              width: screenWidth * 0.3,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: InkWell(
                onTap: () {
                  // check projectName and projectKey -> add db project
                  _checkNewProject();
                },
                child: CustomButtonView(title: 'Create'),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
