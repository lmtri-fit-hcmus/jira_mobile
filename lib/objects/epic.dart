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
  List<Sprint> list_sprint;
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
      this.list_sprint);
}
