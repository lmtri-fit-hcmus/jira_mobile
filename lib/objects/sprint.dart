import 'package:jira_mobile/objects/comment.dart';
import 'package:jira_mobile/objects/issue.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Sprint {
  String _id;
  String _epic_id; //id of epic
  String _name;
  String _goal;
  String _status;
  DateTime _start_date;
  DateTime _due_date;
  List<Issue> _list_issue;

  Sprint(this._id, this._epic_id, this._name, this._goal, this._status,
      this._start_date, this._due_date, this._list_issue);
}

class SprintModel {
  ObjectId? _id;
  ObjectId? project;
  String? name;
  String? goal;
  String? status;
  Timestamp? startDate;
  Timestamp? dueDate;

  ObjectId? get getId => _id;

  SprintModel();

  fromJson(Map json) {
    _id = json["_id"];
    name = json["name"];
    project = json["project"];
    startDate = json["startDate"];
    goal = json["goal"];
    status = json["status"];
    dueDate = json["dueDate"];
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': _id,
      'project': project,
      'name': name,
      'goal': goal,
      'status': status,
      'dueDate': dueDate,
      'startDate': startDate,
    };
  }
}
