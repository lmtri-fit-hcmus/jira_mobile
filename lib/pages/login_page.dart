import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jira_mobile/custom_widgets/custom_button.dart';
import 'package:jira_mobile/networks/account_request.dart';
import 'package:jira_mobile/objects/user.dart';
import 'package:jira_mobile/pages/change_password_page.dart';
import 'package:jira_mobile/pages/home_screen_page.dart';
import 'package:jira_mobile/pages/project_main_page.dart';
import 'package:jira_mobile/pages/signup_page.dart';
import 'package:jira_mobile/values/share_keys.dart';
import 'package:mongo_dart/mongo_dart.dart' as mg;
import 'package:password_text_field/password_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../objects/appinfo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<User> listAccInf = [];
  fetchAccount() {
    Future<List<User>> res = AccountRequest.fetchAccoutInfo();
    res.then((dataFromServer) {
      setState(() {
        listAccInf = dataFromServer;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchAccount();
    });
  }

  String userName = "";
  String password = "";
  String errStr = "";


  setProfileInfo(String _accId,String _name,String _email,String _phone,double _time_performance,String _profile_picture) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppKey.accountId, _accId).then((bool success) {});
    prefs.setString(AppKey.name, _name).then((bool success) {});
    prefs.setString(AppKey.username, userName).then((bool success) {});
    prefs.setString(AppKey.email, _email).then((bool success) {});
    prefs.setString(AppKey.phone, _phone).then((bool success) {});
    prefs.setDouble(AppKey.time_performance, _time_performance).then((bool success) {});
    prefs.setString(AppKey.profile_picture, _profile_picture).then((bool success) {});
  }

  @override
  Widget build(BuildContext context) {
    String invalidUsername = "Inavailable username!";
    String invalidPassword = "Password is not correct!";
    Future<void> onFetch() async {
      setState(() {
        fetchAccount();
      });
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/entry/background.png'),
                    fit: BoxFit.fill)),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 50),
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 100,
                  child: Text(
                    'LOG IN',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade100))),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    userName = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Username",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: PasswordTextField(
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Text(
                          '$errStr',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          int i = 0;
                          print(listAccInf.length);
                          for (; i < listAccInf.length; i++) {
                            print(listAccInf[i].username! +
                                listAccInf[i].password!);
                            if (listAccInf[i].username == userName) {
                              if (listAccInf[i].password == password) {
                                setState(() {
                                  errStr = "";
                                  setProfileInfo(listAccInf[i].getAccountId(), listAccInf[i].name??"", listAccInf[i].email??"", listAccInf[i].phone??"", listAccInf[i].time_performance??0, listAccInf[i].profile_picture??"");
                                  GetIt.instance<AppInfo>().current_user = User(mg.ObjectId.fromHexString(listAccInf[i].getAccountId()), "","",'', '', "","",0.0,[]);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen(
                                                userId: listAccInf[i]
                                                    .getAccountId(),
                                              )),
                                      (route) => false);
                                });
                                break;
                              } else {
                                setState(() {
                                  errStr = invalidPassword;
                                });
                                break;
                              }
                            }
                          }
                          if (i == listAccInf.length && errStr == "") {
                            setState(() {
                              errStr = invalidUsername;
                            });
                          }
                        },
                        child: CustomButtonView(
                          title: "Login",
                        ),
                      ),
                      Container(
                          width: 350,
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                            width: 2,
                            color: Colors.black,
                          ))),
                          child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 10),
                              child: Text('Don\'t have an account?'))),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupPage(
                                        onFet: onFetch,
                                        list: listAccInf,
                                      )));
                        },
                        child: CustomButtonView(
                          title: "Create an account for Jira Mobile?",
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
    ;
  }
}
