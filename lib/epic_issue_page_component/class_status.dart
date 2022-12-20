import 'package:flutter/material.dart';
enum IssueStatusType {
  toDo, inProgress, done
}
const Map<IssueStatusType, Color> backgroundStatus = {
  IssueStatusType.toDo:  Color.fromARGB(255, 88, 85, 85),
  IssueStatusType.inProgress:  Color.fromARGB(249, 12, 69, 213),
  IssueStatusType.done:  Color.fromARGB(255, 5, 229, 64)

};

class Status {
  late final String _data;
  late final Color _color;
  late final IssueStatusType _type;

  Status(this._type, this._data, this._color);
  IssueStatusType get type => _type;
  String get data => _data;
  Color get color => _color;
}
