import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jira_mobile/objects/user.dart';
import 'package:jira_mobile/pages/project_details_page.dart';
import 'package:jira_mobile/pages/project_features_page.dart';

import '../objects/appinfo.dart';
import '../objects/project.dart';

class SettingsViewWidget extends StatefulWidget {
  Function refresh_callback;
  SettingsViewWidget({Key? key, required this.refresh_callback}) : super(key: key);

  @override
  _SettingsViewWidgetState createState() => _SettingsViewWidgetState();
}

class _SettingsViewWidgetState extends State<SettingsViewWidget> {
  User current_user = GetIt.instance<AppInfo>().current_user;
  Project current_project = GetIt.instance<AppInfo>().current_project;

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectDetailsPageWidget(refresh_callback: renew_project)));
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectDetailsPageWidget(refresh_callback: renew_project)));
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectFeaturesPageWidget()));
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
        ],
      ),
    );
  }
}
