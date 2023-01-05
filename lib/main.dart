import 'package:flutter/material.dart';
import 'package:jira_mobile/dbhelper/mongodb.dart';
import 'package:jira_mobile/objects/appdb.dart';
import 'package:jira_mobile/pages/change_password_page.dart';
import 'package:jira_mobile/pages/epic_page.dart';
import 'package:jira_mobile/pages/issue_page.dart';
//import 'package:jira_mobile/pages/epic_page.dart';
import 'package:jira_mobile/pages/login_page.dart';
//import 'package:jira_mobile/pages/issue_page.dart';
import 'package:jira_mobile/pages/create_project_page.dart';
import 'package:jira_mobile/pages/login_page.dart';
import 'package:jira_mobile/pages/home_screen_page.dart';
import 'package:jira_mobile/pages/project_board.dart';
import 'package:jira_mobile/pages/project_main_page.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'objects/appinfo.dart';
import 'objects/project.dart' as custom;
import 'objects/user.dart';
import 'package:get_it/get_it.dart';

final getit = GetIt.instance;
final User user1 = User(ObjectId.parse('63a6ccc438cd7617e0e18e6b'),"user2", "user2", "456", "Le Minh Tri", "", "", 0.0, []);
final custom.Project cur_project = custom.Project(ObjectId.parse('63a3225cf09342b9f7c080c5'), 'Test project 01', 'PROJ-01', ObjectId.parse('63a6ccc438cd7617e0e18e6b'), 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTq8lnfQkQZioZCMqDjQrRaU7r438bhXKGtgQ&usqp=CAU', null, [], []);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();

  var appinfo = AppInfo();
  // on successful sign in
  // re-assign this ...
  appinfo.current_user = user1;
  appinfo.current_project = cur_project;
  //
  //

  var appdb = AppDB();
  await appdb.connect();
  getit.registerSingleton<AppDB>(appdb);
  getit.registerSingleton<AppInfo>(appinfo);
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
        primarySwatch: Colors.blue
      ),
      //debugShowCheckedModeBanner: false,
      //home: ProjectMainPageWidget()
      //home: const ChangePasswordPage(),
      //home: const HomeScreen(userId: "63a185f5205dbf518ca4ab52"),
      //home: const CreateProject(),
      //home: const BoardTab(),
      home: LoginPage()
    );
  }
}
