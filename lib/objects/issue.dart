import 'package:jira_mobile/objects/comment.dart';

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
