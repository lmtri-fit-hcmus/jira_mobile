import 'package:flutter/material.dart';
import 'package:jira_mobile/models/account_info.dart';
import 'package:jira_mobile/objects/appdb.dart';
import 'package:jira_mobile/pages/change_password_page.dart';
import 'package:jira_mobile/pages/epic_page.dart';
import 'package:jira_mobile/pages/login_page.dart';
import 'package:jira_mobile/pages/issue_page.dart';
import 'package:jira_mobile/pages/create_project_page.dart';
import 'package:jira_mobile/pages/login_page.dart';
import 'package:jira_mobile/pages/home_screen_page.dart';
import 'package:jira_mobile/pages/project_main_page.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'objects/project.dart' as custom;
import 'objects/user.dart';
import 'package:get_it/get_it.dart';

final getit = GetIt.instance;

void main() async {
  var appdb = AppDB();
  await appdb.connect();
  getit.registerSingleton<AppDB>(appdb);
  runApp(const JiraMobile());
}

class JiraMobile extends StatelessWidget {
  const JiraMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //debugShowCheckedModeBanner: false,
      home: ProjectMainPageWidget(
        current_user: User(ObjectId.parse('63a185f5205dbf518ca4ab52'),"tri.le", "tri.le", "11111111", "full name", "email", "phone", "", 0.0, []),
        current_project: custom.Project(ObjectId.parse('63a3225cf09342b9f7c080c5'), 'Test project 01', 'PROJ-01', ObjectId.parse('63a185f5205dbf518ca4ab52'), null, null, [], []))
      //home: const ChangePasswordPage(),
      //home: const HomeScreen(),
      //home: const CreateProject(),
    );
  }
}
