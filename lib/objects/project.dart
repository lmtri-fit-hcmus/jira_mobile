// <<<<<<< HEAD
import 'package:jira_mobile/objects/epic.dart';
import 'package:jira_mobile/objects/user.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Project {
  ObjectId id;
  String name;
  String key;
  ObjectId leader; //id of user
  String? avatar;
  DateTime? start_date;
  List<User> list_member;
  List<Epic> list_epic;
  Project(this.id, this.name, this.key, this.leader, this.avatar,
      this.start_date, this.list_member, this.list_epic);
}
// =======
// import 'package:flutter/material.dart';
//
// class Project {
//   String name;
//   String key;
//   // constructor
//   Project({required this.name,required this.key});
// }
//>>>>>>> 243d4a5 (jira_huy)
