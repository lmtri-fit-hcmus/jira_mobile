import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
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
Status setStatus(String value) {
  IssueStatusType type = IssueStatusType.toDo;
  String data = "TO DO" ;
  Color color = backgroundStatus[IssueStatusType.toDo]!;
    switch(value){
      case "TO DO":
        type = IssueStatusType.toDo;
        data = "TO DO";
        color = backgroundStatus[IssueStatusType.toDo]!;
        break;
      case "IN PROGRESS":
        type = IssueStatusType.inProgress;
        data = "IN PROGRESS";
        color = backgroundStatus[IssueStatusType.inProgress]!;
        break;
      case "DONE":
        type = IssueStatusType.done;
        data = "DONE";
        color = backgroundStatus[IssueStatusType.done]!;
        break;
    }
    return Status(type, data, color);
  }