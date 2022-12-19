import 'package:jira_mobile/objects/epic.dart';
import 'package:jira_mobile/objects/user.dart';

class Project {
  String _id;
  String _name;
  String _key;
  User _leader; //id of user
  String _avatar;
  DateTime _start_date;
  List<User> _list_member;
  List<Epic> _list_epic;
  Project(this._id, this._name, this._key, this._leader, this._avatar,
      this._start_date, this._list_member, this._list_epic);
}
