import 'dart:convert';
import 'package:jira_mobile/objects/user.dart';
import "package:mongo_dart/mongo_dart.dart";
import 'package:flutter/foundation.dart';

class NotiRequest {
  static const String server =
      "mongodb+srv://jiraclone:group03@clonejira.yknhuht.mongodb.net/jira";
  static String body = "";
  static var db = null;

  static Future<DbCollection> LoadServer() async {
    db = await Db.create(server);
    await db.open();
    var acc = db.collection('notifications');
    return acc;
  }

  static void closeDB() {
    if (db != null) db.close();
  }

  static Future<void> addNoti(String noti, ObjectId accountId) async {
    var acc = await LoadServer();
    var list = [];
    await acc.find().forEach((element) {
      if (element["accountId"] == accountId) {
        list = element["listNoti"];
      }
    });
    list.add(noti);
    if (list.length==1) {
      await acc.insert({
        "accountId": accountId,
        "listNoti": list,
      });
    }
    await acc.updateOne(
        where.eq("accountId", accountId), modify.set("listNoti", list));
  }

  static Future<List<dynamic>> fetchNoti(ObjectId accountId) async{
    List<dynamic> res = [];
    var acc = await LoadServer();
    await acc.find().forEach((element) {
      if (element["accountId"] == accountId) {
        res = element["listNoti"];
      }
    });
    return res;
  }

}
