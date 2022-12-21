import 'package:flutter/material.dart';
import 'package:jira_mobile/custom_widgets/custom_button.dart';
import 'package:jira_mobile/models/account_info.dart';
import 'package:jira_mobile/networks/account_request.dart';
import 'package:jira_mobile/values/share_keys.dart';
import 'package:password_text_field/password_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordPage extends StatefulWidget {
  final void Function() onFet;
  const ChangePasswordPage({super.key, required this.onFet});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String? accountId = "";

  String currentPass = "";
  String newPass = "";
  String reEnterPass = "";
  int errType = 4;
  List listErrorStr = [
    "Current password is not correct!",
    "New password is not match!",
    "New password too short!",
    "New password sames as old passord ",
    "",
  ];

  setCurPas(s) {
    setState(() {
      currentPass = s;
    });
  }

  setNewPas(s) {
    setState(() {
      newPass = s;
    });
  }

  setRePas(s) {
    setState(() {
      reEnterPass = s;
    });
  }

  x() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      accountId = prefs.getString(AppKey.AccountID);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      x();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Error: ${listErrorStr[errType]}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Change password',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            selfDefine_TextInput(
              title: "Current password",
              setText: setCurPas,
            ),
            SizedBox(
              height: 30,
            ),
            selfDefine_TextInput(title: "New password", setText: setNewPas),
            selfDefine_TextInput(
                title: "Re-enter new password", setText: setRePas),
            Container(
              padding: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              height: 30,
              child: Text(
                listErrorStr[errType],
                style: TextStyle(color: Colors.red),
              ),
            ),
            InkWell(
              
              onTap: () {
                print("cur $currentPass");
                print("new $newPass");
                print("re $reEnterPass");
                NetworkRequest.fetchAccoutInfo().then((dataFromServer) {
                  dataFromServer.forEach((element) {
                    if (element.accountId == accountId) {
                      if (currentPass != element.password) {
                        setState(() {
                          errType = 0;
                        });
                      } else if (newPass != reEnterPass) {
                        setState(() {
                          errType = 1;
                        });
                      } else if (newPass.length < 8) {
                        setState(() {
                          errType = 2;
                        });
                      } else if (currentPass == newPass) {
                        setState(() {
                          errType = 3;
                        });
                      } else {
                        setState(() {
                          errType = 4; //change success!
                        });

                        NetworkRequest.changePasswordRequest(
                                accountId ?? "", newPass, dataFromServer)
                            .then((value) {
                          print("after send");
                          widget.onFet();
                          Navigator.pop(context);
                        });
                      }
                    }
                  });
                });
              },
              child: CustomButtonView(title: "Save"),
            )
          ],
        ),
      ),
    );
  }
}

class selfDefine_TextInput extends StatelessWidget {
  final Function setText;
  final String title;
  const selfDefine_TextInput(
      {super.key, required this.title, required this.setText});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: const EdgeInsets.all(9.0),
        alignment: Alignment.centerLeft,
        child: Text(
          this.title,
        ),
      ),
      Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            border:
                Border.fromBorderSide(BorderSide(color: Colors.grey.shade400))),
        child: PasswordTextField(
          onChanged: (value) {
            this.setText(value);
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: this.title,
              hintStyle: TextStyle(color: Colors.grey[400])),
        ),
      ),
    ]);
  }
}
