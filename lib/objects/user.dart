import 'package:jira_mobile/objects/epic.dart';
import 'package:mongo_dart/mongo_dart.dart';

class User {
  /*====================================================================*/
  ObjectId id;
  String accountId;
  String username;
  String password;
  String full_name;
  String email;
  String phone;
  String profile_picture;
  double time_perform;
  List<Epic> list_epic;
  /*====================================================================*/

  User(this.id, this.accountId, this.username, this.password, this.full_name, this.email,
      this.phone, this.profile_picture, this.time_perform, this.list_epic);
}
