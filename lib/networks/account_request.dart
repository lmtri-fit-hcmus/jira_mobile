import 'dart:convert';
import 'package:jira_mobile/objects/user.dart';
import "package:mongo_dart/mongo_dart.dart";
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AccountRequest {
  static const String server =
      "mongodb+srv://jiraclone:group03@clonejira.yknhuht.mongodb.net/jira";
  static String body = "";
  static var db = null;

  static Future<DbCollection> LoadServer() async {
    db = await Db.create(server);
    await db.open();
    var acc = db.collection('users');
    return acc;
  }

  static void closeDB() {
    if (db != null) db.close();
  }

  static Future<bool> addMemberToProject(
      String emails, ObjectId projectId) async {
    bool res = false;
    var acc = await LoadServer();
    var tmp = [];
    bool check = false;
    await acc.find().forEach((element) async {
      if (element["email"] == emails) {
        var db2 = await Db.create(server);
        await db2.open();
        var a = db.collection('projects');
        await a.find().forEach((element2) {
          if (element2['_id'] == projectId) {
            tmp = element2["members"];
            tmp.forEach((e) {
              if (e == element["_id"]) check = true;
            });
            if (!check) {
              tmp.add(element["_id"]);
              a.updateOne(
                  where.eq('_id', projectId), modify.set('members', tmp));
            }
          }
        });

        res = true;
      }
    });
    return res;
  }

  static List<User> parseAccountInfo(String responseBody) {
    var list = jsonDecode(responseBody) as List<dynamic>;
    List<User> listAccInf = list.map((e) => User.fromJson(e)).toList();
    return listAccInf;
  }

  static Future<List<User>> fetchAccoutInfo({int page = 1}) async {
    var acc = await LoadServer().then((value) => value);
    String body = "[";
    int i = 0;
    await acc.find().forEach((element) {
      String tmp = "{";
      tmp += "\"_id\":\"";
      tmp += ((element["_id"].toString().replaceAll("ObjectId(\"", ""))
          .replaceAll("\")", ""));
      tmp += "\",\"username\":\"";
      tmp += element["username"];
      tmp += "\",\"password\":\"";
      tmp += element["password"];
      tmp += "\",\"name\":\"";
      tmp += element["name"];
      tmp += "\",\"email\":\"";
      tmp += element["email"];
      tmp += "\",\"phone\":\"";
      tmp += element["phone"];
      tmp += "\",\"profile_picture\":\"";
      tmp += element["profile_picture"];
      tmp += "\",\"time_performance\":\"";
      tmp += element["time_performance"].toString();
      tmp += "\"}";
      body += tmp;
      body += ",";
    });
    body = body.substring(0, body.length - 1);
    body += ']';
    closeDB();
    return compute(parseAccountInfo, body);
  }

  static Future<void> sendAccountInfor(String userName, String password,
      String name, String phone, String email) async {
    var acc = await LoadServer();
    await acc.insert({
      'username': "$userName",
      'password': "$password",
      'name': "$name",
      'phone': "$phone",
      'email': "$email",
      'profile_picture': "",
      'time_performance': 0
    });
    closeDB();
  }

  static Future<void> changePasswordRequest(
      String id, String newPass, List<User> list) async {
    var acc = await LoadServer();
    await acc.updateOne(
        where.eq('_id',ObjectId.fromHexString(id)), modify.set('password', newPass));
    closeDB();
  }
}
