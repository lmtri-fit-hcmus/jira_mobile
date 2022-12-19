import 'package:jira_mobile/objects/comment.dart';
import 'package:jira_mobile/objects/issue.dart';

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
