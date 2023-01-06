import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:jira_mobile/pages/change_password_page.dart';
import 'package:jira_mobile/pages/login_page.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../values/share_keys.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String accountId = "";
  String username = "";
  String name = "";
  String email = "";
  String phone = "";
  double time_performance = 0;
  String profile_picture = "";
  void getAccountInfor() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      accountId = prefs.getString(AppKey.accountId) ?? "";
      username = prefs.getString(AppKey.username) ?? "";
      name = prefs.getString(AppKey.name) ?? "";
      email = prefs.getString(AppKey.email) ?? "";
      phone = prefs.getString(AppKey.phone) ?? "";
      time_performance = (prefs.getDouble(AppKey.time_performance) ?? 0);
      profile_picture = prefs.getString(AppKey.profile_picture) ?? "";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getAccountInfor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      
      body: Container(
        child: Stack(children: [
          
          Container(
            child: Image.asset('assets/images/entry/bkgr.png'),
          ),
          Container(
            child: Image.asset('assets/images/entry/circle.png'),
          ),
          Container(
            child: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context);},),
          ),
          Column(
            children: [
              Column(children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 150, bottom: 5),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            image: new DecorationImage(
                                image: AssetImage(
                                    'assets/images/entry/background.png')),
                            shape: BoxShape.circle),
                      ),
                      Container(
                        margin: EdgeInsets.all(2),
                        child: Text(
                          "${name}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),
          Expanded(
            flex: 1,
            child: Column(children: [
              Expanded(flex: 4, child: Container()),
              Expanded(
                  flex: 2,
                  child: Container(
                      child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10, bottom: 5),
                          child: Text("@$username")),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Text("Email: $email"),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Text("Phone Number: $phone"),
                      ),
                      Container(
                          margin: EdgeInsets.all(5),
                          child: Text("Time Performance: $time_performance")),
                    ],
                  ))),
              Expanded(
                flex: 2,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Line(
                      ic: Icons.password,
                      text: 'Change password',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePasswordPage()));
                      },
                    ),
                    Line(
                        ic: Icons.logout,
                        text: 'Log out',
                        onTap: () {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              text: 'Do you want to logout',
                              confirmBtnText: 'Yes',
                              cancelBtnText: 'No',
                              confirmBtnColor: Color.fromARGB(0, 31, 105, 110),
                              onConfirmBtnTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                    (route) => false);
                              });
                        }),
                  ],
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class Line extends StatelessWidget {
  final void Function() onTap;
  final IconData ic;
  final String text;
  const Line(
      {super.key, required this.ic, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 20),
        height: 60,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 30),
              child: Icon(
                this.ic,
                size: 40,
              ),
            ),
            Text(this.text)
          ],
        ),
      ),
    );
  }
}
