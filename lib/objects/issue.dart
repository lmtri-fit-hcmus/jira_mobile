import 'package:jira_mobile/objects/comment.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Issue {
  String _id;
  String _name;
  String _goal;
  String _issue_type;
  String _description;
  String _status;
  String _assignee; //id of user
  String _reporter; //id of user
  DateTime _start_date;
  DateTime _due_date;
  List<Comment> _list_cmt;

  int _priority;
  Issue(
      this._id,
      this._name,
      this._goal,
      this._issue_type,
      this._description,
      this._status,
      this._assignee, //id of user
      this._reporter, //id of user
      this._start_date,
      this._due_date,
      this._priority,
      this._list_cmt);
}

class IssueModel {
  ObjectId? _id;
  ObjectId? reporter;
  ObjectId? assignee;
  String? issueType;
  String? name;
  String? description;
  String? status;
  int? priority;
  Timestamp? startDate;
  Timestamp? dueDate;

  IssueModel();
  IssueModel.withName(this._id, this.name, this.issueType, this.status);

  ObjectId? get getId => _id;

  fromJson(Map json) {
    _id = json["_id"];
    name = json["name"];
    issueType = json["issueType"];
    reporter = json["reporter"];
    assignee = json["assignee"];
    startDate = json["startDate"];
    priority = json["priority"];
    description = json["description"];
    status = json["status"];
    dueDate = json["dueDate"];
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': _id,
      'issueType': issueType,
      'reporter': reporter,
      'assignee': assignee,
      'name': name,
      'description': description,
      'priority': priority,
      'status': status,
      'dueDate': dueDate,
      'startDate': startDate,
    };
  }
}
