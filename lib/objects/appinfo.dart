import 'package:jira_mobile/objects/project.dart';
import 'package:jira_mobile/objects/user.dart';
import 'package:mongo_dart/mongo_dart.dart' as md;

class AppInfo {
  late User current_user;
  late Project current_project;

  AppInfo() {
    current_user = User(md.ObjectId(), '', '', '', '', '', '', 0, []);
    current_project = Project(md.ObjectId(), '', '', md.ObjectId(), null, null, [], []);
  }
}