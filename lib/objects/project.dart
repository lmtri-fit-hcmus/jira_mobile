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

class ProjectModel {
  ObjectId? _id;
  String? name;
  String? key;
  String? avatar;
  ObjectId? leader;
  Timestamp? startDate;
  List<dynamic>? members;

  ProjectModel();

  ObjectId? get getId => _id;

  fromJson(Map json) {
    _id = json["_id"];
    name = json["name"];
    key = json["key"];
    avatar = json["avatar"];
    leader = json["leader"];
    startDate = json["startDate"];
    members = json["members"];
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': _id,
      'name': name,
      'key': key,
      'avatar': avatar,
      'leader': leader,
      'startDate': startDate,
      'members': members,
    };
  }
}
