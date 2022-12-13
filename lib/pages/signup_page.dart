import 'package:flutter/material.dart';
import 'package:jira_mobile/models/account_info.dart';
import 'package:jira_mobile/networks/account_request.dart';
import 'package:password_text_field/password_text_field.dart';

class SignupPage extends StatefulWidget {
  final void Function() onFet;
  final List<AccountInfo> list;
  const SignupPage({super.key, required this.onFet, required this.list});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _userName = "";
  String _password = "";
  String _reEnterPassword = "";
  bool isMatch = true;
  bool isValid = true;
  List<AccountInfo> listAccInf = [];
  String currentState = "";

  @override
  Widget build(BuildContext context) {
    bool checkValidAccount(String useName, String pass) {
      setState(() {
        listAccInf = widget.list;
      });
      for (int i = 0; i < listAccInf.length; i++) {
        if (listAccInf[i].userName == useName) {
          return false;
        }
      }
      return true;
    }

    String notMatch = "re-enter password is not matched!";
    String userNotValid = "Username is taken by another!";
    String passwordInValid = "Password is at least 8 characters";
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
                  height: 100,
                  child: Text(
                    'SIGN UP',
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
                                          color: Colors.grey.shade400))),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _userName = value;
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
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey.shade100))),
                              padding: EdgeInsets.all(8.0),
                              child: PasswordTextField(
                                onChanged: (value) {
                                  setState(() {
                                    _password = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: PasswordTextField(
                                onChanged: (value) {
                                  setState(() {
                                    _reEnterPassword = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Re-Enter Password",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(currentState,
                              style: TextStyle(
                                  color: isMatch && isValid
                                      ? Colors.white
                                      : Colors.red))),
                      Container(
                        padding: const EdgeInsets.only(bottom: 20, top: 20),
                        width: 200,
                        alignment: Alignment.centerRight,
                        child: Text(
                            'By sign up, you agree the User Notice and Privacy Policy'),
                      ),
                      InkWell(
                        onTap: () {
                          //

                          if (_password == _reEnterPassword) {
                            setState(() {
                              isMatch = true;
                            });
                            if (_password.length < 8) {
                              setState(() {
                                currentState = passwordInValid;
                                isValid = false;
                              });
                            } else if (checkValidAccount(
                                _userName, _password)) {
                              NetworkRequest.sendAccountInfor(
                                      _userName, _password, _userName)
                                  .then((value) {
                                widget.onFet();
                                Navigator.pop(context);
                              });
                            } else {
                              setState(() {
                                currentState = userNotValid;
                                isValid = false;
                              });
                            }
                          } else {
                            setState(() {
                              isMatch = false;
                              currentState = notMatch;
                            });
                            print('Not Match');
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 2),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ])),
                          child: Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
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
