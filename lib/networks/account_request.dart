import 'dart:convert';
import "package:mongo_dart/mongo_dart.dart";
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jira_mobile/models/account_info.dart';
import 'package:http/http.dart' as http;

class NetworkRequest {
  static const String server =
      "mongodb+srv://jiraclone:group03@clonejira.yknhuht.mongodb.net/account";
  static String body = "";

  static Future<DbCollection> LoadServer() async {
    var db = await Db.create(server);
    await db.open();
    var acc = db.collection('account');
    return acc;
  }

  static List<AccountInfo> parseAccountInfo(String responseBody) {
    var list = jsonDecode(responseBody) as List<dynamic>;
    List<AccountInfo> listAccInf =
        list.map((e) => AccountInfo.fromJson(e)).toList();
    return listAccInf;
  }

  static Future<List<AccountInfo>> fetchAccoutInfo({int page = 1}) async {
    var acc = await LoadServer().then((value) => value);
    String body = "[";
    int i = 0;
    await acc.find().forEach((element) {
      String tmp = "{";
      tmp += "\"userName\":\"";
      tmp += element["userName"];
      tmp += "\",\"accountId\":\"";
      tmp += element["accountId"];
      tmp += "\",\"password\":\"";
      tmp += element["password"];
      tmp += "\"}";
      body += tmp;
      body += ",";
    });
    body = body.substring(0, body.length - 1);
    body += ']';
    return compute(parseAccountInfo, body);
  }

  static Future<void> sendAccountInfor(
      String userName, String password, String id) async {
    var acc = await LoadServer();
    await acc.insert(
        {'userName': "$userName", 'password': "$password", 'accountId': "$id"});
  }

  static Future<void> changePasswordRequest(
      String id, String newPass, List<AccountInfo> list) async {
    var acc = await LoadServer();
    await acc.updateOne(
        where.eq('accountId', id), modify.set('password', newPass));
  }
}
