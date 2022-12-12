import 'package:flutter/material.dart';
import 'package:jira_mobile/networks/account_request.dart';
import 'package:password_text_field/password_text_field.dart';
import 'package:password_validated_field/password_validated_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../values/share_keys.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _userName = "";
  String _password = "";
  String _reEnterPassword = "";
  bool isMatch = true;

  @override
  Widget build(BuildContext context) {
    // c()async{
    //   print('gohere');
    //   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    //   final SharedPreferences prefs = await _prefs;
    //   String p = prefs.get(AppKey.AccountID).toString();
    //   print(p);
    // }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
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
                        child: Text('re-enter password is not matched!', style: TextStyle(color: isMatch?Colors.white : Colors.red))),
                      Container(
                        padding: const EdgeInsets.only(bottom: 20, top: 20),
                        width: 200,
                        alignment: Alignment.centerRight,
                        child: Text('By sign up, you agree the User Notice and Privacy Policy'),
                      ),
                      InkWell(
                        onTap: (){
                          if(_password == _reEnterPassword){
                            setState(() {
                              isMatch = true;
                            });
                            print('{$_password} match');
                            NetworkRequest.sendAccountInfor(_userName, _password, "1234");
                            
                          }
                          else{
                            setState(() {
                              isMatch = false;
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
