import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jira_mobile/networks/account_request.dart';
import 'package:jira_mobile/objects/user.dart';
import 'package:jira_mobile/pages/project_details_page.dart';
import 'package:jira_mobile/pages/project_features_page.dart';

import '../objects/appinfo.dart';
import '../objects/project.dart';

class SettingsViewWidget extends StatefulWidget {
  Function refresh_callback;
  SettingsViewWidget({Key? key, required this.refresh_callback})
      : super(key: key);

  @override
  _SettingsViewWidgetState createState() => _SettingsViewWidgetState();
}

class _SettingsViewWidgetState extends State<SettingsViewWidget> {
  User current_user = GetIt.instance<AppInfo>().current_user;
  Project current_project = GetIt.instance<AppInfo>().current_project;
  String invitedEmails = "";

  void renew_project() {
    setState(() {
      current_project = GetIt.instance<AppInfo>().current_project;
    });
    widget.refresh_callback();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProjectDetailsPageWidget(
                          refresh_callback: renew_project)));
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                  child: Text(
                    'Details',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProjectDetailsPageWidget(
                                refresh_callback: renew_project)));
                  },
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProjectFeaturesPageWidget()));
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                  child: Text(
                    'Features',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: 25,
                  ),
                  onPressed: () {
                    // to features page
                  },
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return new Scaffold(
                      body: Center(
                          child: Container(
                        width: double.infinity,
                        height: 300,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(51, 55, 55, 55),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: Text("Add a member to project"),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              margin: EdgeInsets.only(
                                  top: 30, left: 20, right: 20, bottom: 20),
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(color: Colors.grey.shade400),
                                left: BorderSide(color: Colors.grey.shade400),
                                right: BorderSide(color: Colors.grey.shade400),
                                top: BorderSide(color: Colors.grey.shade400),
                              )),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    invitedEmails = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "@emails",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              top: 20, left: 20, right: 20),
                                          decoration: BoxDecoration(
                                              border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade400),
                                            left: BorderSide(
                                                color: Colors.grey.shade400),
                                            right: BorderSide(
                                                color: Colors.grey.shade400),
                                            top: BorderSide(
                                                color: Colors.grey.shade400),
                                          )),
                                          width: 100,
                                          height: 50,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Cancel"),
                                          )),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade400),
                                            left: BorderSide(
                                                color: Colors.grey.shade400),
                                            right: BorderSide(
                                                color: Colors.grey.shade400),
                                            top: BorderSide(
                                                color: Colors.grey.shade400),
                                          )),
                                          margin: EdgeInsets.only(
                                              top: 20, left: 20, right: 20),
                                          width: 100,
                                          height: 50,
                                          child: InkWell(
                                            onTap: () {
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
                                              AccountRequest.addMemberToProject(
                                                      invitedEmails,
                                                      current_project.id)
                                                  .then((value) {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Text('Done'),
                                          )),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      )),
                    );
                  });
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                  child: Text(
                    'Add member',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: 25,
                  ),
                  onPressed: () {
                    // to features page
                  },
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
