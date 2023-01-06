import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jira_mobile/objects/appdb.dart';
import 'package:mongo_dart/mongo_dart.dart' as md;

import '../objects/appinfo.dart';
import '../objects/project.dart';
import '../objects/user.dart';

class EditProjectNamePageWidget extends StatefulWidget {
  Function refresh_callback;
  EditProjectNamePageWidget({Key? key, required this.refresh_callback}) : super(key: key);

  @override
  _EditProjectNamePageWidgetState createState() =>
      _EditProjectNamePageWidgetState();
}

class _EditProjectNamePageWidgetState extends State<EditProjectNamePageWidget> {
  TextEditingController? textController;
  User current_user = GetIt.instance<AppInfo>().current_user;
  Project current_project = GetIt.instance<AppInfo>().current_project;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController?.dispose();
    super.dispose();
  }

  void handle() async {
    var new_proj_name = textController?.text;
    if (new_proj_name == null || new_proj_name.length <= 0)
    {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Project\'s name can\'t be empty')));
      return;
    }

    var is_authorized = await isAuthorized();
    if (!is_authorized) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Only the project leader can change project\'s name')));
      return;
    }

    var coll = GetIt.instance<AppDB>().main_db.collection('projects');
    var res = await coll.updateOne(md.where.eq('_id', current_project.id), md.modify.set('name', new_proj_name));
    if (res.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successfully updated project\'s name')));
      setState(() {
        GetIt.instance<AppInfo>().current_project.name = new_proj_name;
      });
      widget.refresh_callback();
      Navigator.pop(context);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update project\'s name, please try again')));
    }
  }

  Future<bool> isAuthorized() async {
    var coll = GetIt.instance<AppDB>().main_db.collection('projects');
    var res = await coll.findOne(md.where.eq('_id', current_project.id));
    var result = false;
    if (res != null) {
      if (res['leader'] != null && res['leader'] == current_user.id)
        result = true;
    }

    return result;
  }

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
          'Edit project name',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.cyanAccent,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
            child: IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.cyanAccent,
                size: 25,
              ),
              onPressed: () async {
                handle();
              },
            ),
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.transparent,
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 20, 15, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New project name',
                          style:
                          TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextFormField(
                          controller: textController,
                          onChanged: (String text) {
                            // set state
                          },
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'new_project_name',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            suffixIcon: textController!.text.isNotEmpty
                                ? InkWell(
                              onTap: () async {
                                textController?.clear();
                                setState(() {});
                              },
                              child: Icon(
                                Icons.clear,
                                color: Color(0xFF757575),
                                size: 22,
                              ),
                            )
                                : null,
                          ),
                          style:
                          TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
