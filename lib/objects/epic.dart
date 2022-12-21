import 'package:jira_mobile/objects/sprint.dart';

class Epic {
  String id;
  String project_id; //id of project
  String name;
  String status;
  String description;
  DateTime start_date;
  DateTime due_date;
  List<Sprint> list_sprint;
  Epic(
      this.id,
      this.project_id, //id of project
      this.name,
      this.status,
      this.description,
      this.start_date,
      this.due_date,
      this.list_sprint);
}
