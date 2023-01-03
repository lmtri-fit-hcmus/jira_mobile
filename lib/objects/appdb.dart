import 'package:mongo_dart/mongo_dart.dart';

class AppDB {
  String CONNECTION_STRING_1 = "mongodb+srv://jiraclone:group03@clonejira.yknhuht.mongodb.net/account";
  String CONNECTION_STRING_2 = "mongodb+srv://jiraclone:group03@clonejira.yknhuht.mongodb.net/jira";
  var account_db;
  var main_db;

  AppDB() {
    account_db = null;
    main_db = null;
  }

  Future connect() async {
    var db1 = await Db.create(CONNECTION_STRING_1);
    var db2 = await Db.create(CONNECTION_STRING_2);
    await db1.open();
    account_db = db1;
    await db2.open();
    main_db = db2;
  }
}