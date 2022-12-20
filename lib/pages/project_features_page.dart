import 'package:flutter/material.dart';

class ProjectFeaturesPageWidget extends StatefulWidget {
  const ProjectFeaturesPageWidget({Key? key}) : super(key: key);

  @override
  _ProjectFeaturesPageWidgetState createState() =>
      _ProjectFeaturesPageWidgetState();
}

class _ProjectFeaturesPageWidgetState extends State<ProjectFeaturesPageWidget> {
  bool? switchListTileValue1;
  bool? switchListTileValue2;
  bool? switchListTileValue3;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.cyanAccent,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Features',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.cyanAccent,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.transparent,
                  elevation: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://jexo.io/content/images/2021/08/Jira-Roadmaps-2-1.jpg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: SwitchListTile(
                          value: switchListTileValue1 ??= true,
                          onChanged: (newValue) async {
                            setState(() => switchListTileValue1 = newValue!);
                          },
                          title: Text(
                            'Roadmap',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Easily create and manage your epics',
                            style:
                            TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          tileColor: Colors.transparent,
                          dense: false,
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.transparent,
                  elevation: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://nulab.com/images/compare/cards/detailed-issue-list-view.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: SwitchListTile(
                          value: switchListTileValue2 ??= true,
                          onChanged: (newValue) async {
                            setState(() => switchListTileValue2 = newValue!);
                          },
                          title: Text(
                            'Backlog',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Plan and prioritize your team\'s work',
                            style:
                            TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          tileColor: Colors.transparent,
                          dense: false,
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.transparent,
                  elevation: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://atlassianblog.wpengine.com/wp-content/uploads/2018/08/agility-is-better-than-agile_featured@2x.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: SwitchListTile(
                          value: switchListTileValue3 ??= true,
                          onChanged: (newValue) async {
                            setState(() => switchListTileValue3 = newValue!);
                          },
                          title: Text(
                            'Board',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'View, track and manage works',
                            style:
                            TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          tileColor: Colors.transparent,
                          dense: false,
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
