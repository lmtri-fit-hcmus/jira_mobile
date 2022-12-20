class Epic {
  String? id;
  String project_id;
  String name;
  String? description;
  String? status;
  String? assignee_id;
  String? reporter_id;
  String? start_date;
  String? due_date;

  Epic(this.id, this.project_id, this.name, this.description, this.status, this.assignee_id, this.reporter_id, this.start_date, this.due_date);
}