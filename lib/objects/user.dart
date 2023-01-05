import 'package:jira_mobile/objects/epic.dart';
import 'package:mongo_dart/mongo_dart.dart';

class User {
  /*====================================================================*/
  ObjectId? id;
  String? username;
  String? password;
  String? name;
  String? email;
  String? phone;
  String? profile_picture;
  double? time_performance;
  List<Epic>? list_epic;
  /*====================================================================*/

  User(this.id, this.username, this.password, this.name, this.email,
      this.phone, this.profile_picture, this.time_performance, this.list_epic);

  User.fromJson(Map<String, dynamic> json) {
    this.id = ObjectId.fromHexString(json["_id"]);
    this.username = json["username"];
    this.password = json["password"];
    this.name = json["name"];
    this.email = json["email"];
    this.phone = json["phone"];
    this.profile_picture = json["profile_picture"];
    this.time_performance = double.parse(json["time_performance"]);
    this.list_epic = [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['profile_picture'] = this.profile_picture;
    data['time_performance'] = this.time_performance;
    data['list_epic'] = this.list_epic;
    return data;
  }
  String getAccountId(){
    return (this.id.toString().replaceAll("ObjectId(\"", "")).replaceAll("\")", "");
  }
}
