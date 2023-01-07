import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jira_mobile/networks/account_request.dart';
import 'package:password_text_field/password_text_field.dart';

import '../objects/user.dart';

class SignupPage extends StatefulWidget {
  final Future<void> Function() onFet;
  final List<User> list;
  const SignupPage({super.key, required this.onFet, required this.list});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _firstName = "";
  String _lastName = "";
  String _emails = "";
  String _userName = "";
  String _password = "";
  String _reEnterPassword = "";
  String _phone = "";
  bool isMatch = true;
  bool isValid = true;
  List<User> listAccInf = [];
  String currentState = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    bool checkValidAccount(String useName, String pass) {
      setState(() {
        listAccInf = widget.list;
      });
      for (int i = 0; i < listAccInf.length; i++) {
        if (listAccInf[i].username == useName) {
          return false;
        }
      }
      return true;
    }

    String notMatch = "re-enter password is not matched!";
    String userNotValid = "Username is taken by another!";
    String passwordInValid = "Password is at least 8 characters";
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                child: Image.asset('assets/images/entry/background.png'),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(20)),
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromARGB(51, 55, 55, 55),
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors
                                                              .grey.shade400))),
                                              child: TextField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    _firstName = value;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "First Name",
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey[400])),
                                              ))),
                                      Expanded(
                                          flex: 4,
                                          child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      left:
                                                          BorderSide(width: 0.4),
                                                      bottom: BorderSide(
                                                          color: Colors
                                                              .grey.shade400))),
                                              child: TextField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    _lastName = value;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "Last Name",
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey[400])),
                                              ))),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade400))),
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _emails = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Email@",
                                          hintStyle:
                                              TextStyle(color: Colors.grey[400])),
                                    ),
                                  ),
                                   Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade400))),
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _phone = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Phone",
                                          hintStyle:
                                              TextStyle(color: Colors.grey[400])),
                                    ),
                                  ),
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
                                if (_firstName == "" ||
                                    _lastName == "" ||
                                    _userName == "") {
                                  setState(() {
                                    currentState = "Refill";
                                    isValid = false;
                                  });
                                } else if (_password == _reEnterPassword) {
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
                                      
                                     showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.black,
                                                      ),
                                                    );
                                                  });
                                    AccountRequest.sendAccountInfor(
                                            _userName,
                                            _password,
                                            _firstName + " " + _lastName,
                                            _phone,
                                            _emails)
                                        .then((value) {
                                      widget.onFet().then((value) {
                                        Navigator.of(context).pop();
                                        Navigator.pop(context);});
                                      
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
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(width: 2),
                                    gradient: LinearGradient(colors: [
                                      Color.fromARGB(255, 66, 173, 169),
                                      Color.fromARGB(116, 23, 130, 105),
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
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
