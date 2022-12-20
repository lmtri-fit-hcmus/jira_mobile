import 'package:jira_mobile/objects/sprint.dart';

class Epic {
  String _id;
  String _project_id; //id of project
  String _name;
  String _status;
  String _description;
  DateTime _start_date;
  DateTime _due_date;
  List<Sprint> _list_sprint;
  Epic(
      this._id,
      this._project_id, //id of project
      this._name,
      this._status,
      this._description,
      this._start_date,
      this._due_date,
      this._list_sprint);
}
