import 'dart:ffi';

import 'package:jira_mobile/objects/epic.dart';

class User {
  /*====================================================================*/
  String _id;
  String _username;
  String _password;
  String _full_name;
  String _email;
  String _phone;
  String _profile_picture;
  double _time_perform;
  List<Epic> _list_epic;
  /*====================================================================*/

  User(this._id, this._username, this._password, this._full_name, this._email,
      this._phone, this._profile_picture, this._time_perform, this._list_epic);
}
