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

  static Future<String> LoadServer() async {
    var acc =
        await Db.create(server).then((value) => value.collection("account"));
    String res = "[";
    acc.find().forEach((element) {
      res += element.toString();
      res += ",";
    });
    return res;
  }

  static List<AccountInfo> parseAccountInfo(String responseBody) {
    var list = jsonDecode(responseBody) as List<dynamic>;
    List<AccountInfo> listAccInf =
        list.map((e) => AccountInfo.fromJson(e)).toList();
    return listAccInf;
  }

  static Future<List<AccountInfo>> fetchAccoutInfo({int page = 1}) async {
    String response = await LoadServer();
    return compute(parseAccountInfo, response);
  }

  static Future<http.Response> sendAccountInfor(
      String userName, String password, String id) async {
    String r = jsonEncode(<String, String>{
      'userName': userName,
      'password': password,
      'accountId': id
    });
    r = body + "," + r + "]";
    return await http.post(Uri.parse('$server'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: r);
  }

  static Future<http.Response> changePasswordRequest(
      String id, String newPass, List<AccountInfo> list) async {
    String res = "[";
    list.forEach((element) {
      if (element.accountId == id) {
        element.password = newPass;
      }
      res += "{";
      res += "\"password\": \"${element.password}\",";
      res += "\"userName\": \"${element.userName}\",";
      res += "\"accountId\": \"${element.accountId}\"";
      res += "}";
      if (element != list.last) res += ",";
    });
    res += "]";
    print('afer update: $res');
    return await http.post(Uri.parse('$server'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: res);
  }
}

querydb() async {
  var db = await Db.create(
      "mongodb+srv://jiraclone:group03@clonejira.yknhuht.mongodb.net/account");
  await db.open();
  var acc = db.collection('account');
  await acc.find().forEach((v) {
    print(v);
  });
  await db.close();
}
