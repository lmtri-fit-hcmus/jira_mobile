import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jira_mobile/models/account_info.dart';
import 'package:http/http.dart' as http;

class NetworkRequest {
  static const String server = "https://api.npoint.io/6518d068b58799ab1715";
  static String body = "";

  static List<AccountInfo> parseAccountInfo(String responseBody) {
    var list = jsonDecode(responseBody) as List<dynamic>;
    List<AccountInfo> listAccInf =
        list.map((e) => AccountInfo.fromJson(e)).toList();
    return listAccInf;
  }

  static Future<List<AccountInfo>> fetchAccoutInfo({int page = 1}) async {
    final response = await http.get(Uri.parse('$server'));
    if (response.statusCode == 200) {
      print('{$server} parse sucessfully');
      body = response.body.substring(0, response.body.length - 1);
      return compute(parseAccountInfo, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not found server');
    } else {
      throw Exception('Can\'t fetch account infor');
    }
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
