import 'package:jira_mobile/objects/issue.dart';
import 'package:jira_mobile/objects/sprint.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Epic {
  ObjectId id;
  ObjectId project_id; //id of project
  String name;
  String status;
  String description;
  ObjectId? assignee;
  ObjectId? reporter;
  DateTime? start_date;
  DateTime? due_date;
  List<Issue> list_issue;
  Epic(
      this.id,
      this.project_id, //id of project
      this.name,
      this.status,
      this.description,
      this.assignee,
      this.reporter,
      this.start_date,
      this.due_date,
      this.list_issue);
}

class EpicModel {
  ObjectId? _id;
  ObjectId? project;
  ObjectId? reporter;
  ObjectId? assignee;
  String? name;
  String? description;
  String? status;
  Timestamp? startDate;
  Timestamp? dueDate;

  ObjectId? get getId => _id;

  fromJson(Map json) {
    _id = json["_id"];
    name = json["name"];
    project = json["project"];
    reporter = json["reporter"];
    assignee = json["assignee"];
    startDate = json["startDate"];
    description = json["description"];
    status = json["status"];
    dueDate = json["dueDate"];
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': _id,
      'project': project,
      'reporter': reporter,
      'assignee': assignee,
      'name': name,
      'description': description,
      'status': status,
      'dueDate': dueDate,
      'startDate': startDate,
    };
  }
}
