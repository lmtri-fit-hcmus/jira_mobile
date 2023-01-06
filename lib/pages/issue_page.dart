import 'dart:ffi';

import 'package:jira_mobile/dbhelper/mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongodb;
import 'package:jira_mobile/epic_issue_page_component/class_status.dart';
import 'package:flutter/material.dart';
import 'package:jira_mobile/epic_issue_page_component/component.dart';



class IssuePage extends StatefulWidget {
  const IssuePage({super.key});

  @override
  State<IssuePage> createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {
  mongodb.ObjectId _issueId = mongodb.ObjectId.fromHexString('63b6eddc7b823f8aef2f57fd');
  bool _isNavigation = true;
  //handle text field event
  bool _isVisible = false;
  bool _isFirstClick = true;
  final TextEditingController _issueNameController = TextEditingController(text: "");

  //issue status
  Status _status = Status(IssueStatusType.toDo, "TO DO",backgroundStatus[IssueStatusType.toDo]!);

  //epic parent
  String _epicName = '';

  //sprint name
  String _sprintName = '';
  //assignee
  String _assigneeName = "Unassigned";
  var _listMemberId = <mongodb.ObjectId>[];
  var _listMemberUser = <String>[];

  void _fetchData(mongodb.ObjectId id) {
    Future<Map<String,dynamic>> issue = MongoDatabase.getIssue(id);
    issue.then((issueData) {
      //print("issue data is: ${issueData.toString()}");
      setState(() {
              _issueNameController.text = issueData['name'];
              _status = setStatus(issueData['status']);
              //get parent epic of this issue 
              Future<Map<String,dynamic>?> parentEpic = MongoDatabase.getParentEpic(issueData['_id']);
              parentEpic.then((epicData) {

                if(epicData != null) {
                  //print("epic data is ${epicData.toString()}");
                  setState(() {
                    _epicName = epicData['name'];
                  });
                  
                  //get project_member 
                  Future<Map<String,dynamic>?> project = MongoDatabase.getProjectMemberIdByEpic(epicData['project_id']);
                  project.then((projectData) {
                    //print("project data is ${projectData.toString()}");
                    if(projectData != null) {
                      for(int i = 0; i < projectData['members'].length; i++) {
                        _listMemberId.add(projectData['members'][i] as mongodb.ObjectId);
                      }
                      //get member data like name, id, phone_number,...
                      MongoDatabase.getListMemberInProject(_listMemberId).then((value) {
                        for (int i = 0; i < value.length; i++){
                          _listMemberUser.add(value[i]['name']);
                          if(value[i]['_id'] == issueData['assignee']) {
                            setState(() {
                              _assigneeName = value[i]['name'];
                            });
                          }
                        }
                    }
                  );
                }
              }
            );
          }
        }
      );
              //get sprint which this issue is in
              Future<Map<String,dynamic>?> sprint = MongoDatabase.getSprintByIssueId(issueData['_id']);
              sprint.then((sprintData) {
                if(sprintData != null) {
                  //print("sprint data is ${sprintData.toString()}");
                  setState(() {
                    _sprintName = sprintData['name'];
                  });
                  if(_listMemberId.isEmpty) {
                    Future<Map<String,dynamic>?> project = MongoDatabase.getProjectMemberIdByEpic(sprintData['project_id']);
                    project.then((projectData) {
                      //print("project data is ${projectData.toString()}");
                      if(projectData != null) {
                        for(int i = 0; i < projectData['members'].length; i++) {
                          _listMemberId.add(projectData['members'][i] as mongodb.ObjectId);
                        }
                        //get member data like name, id, phone_number,...
                        MongoDatabase.getListMemberInProject(_listMemberId).then((value) {
                          for (int i = 0; i < value.length; i++){
                            _listMemberUser.add(value[i]['name']);
                            if(value[i]['_id'] == issueData['assignee']) {
                              setState(() {
                              _assigneeName = value[i]['name'];
                              });
                            }
                          }
                      }
                    );
                  }
                });                    
                  }
                }
              });

    }
  );
});
}

  

  @override
  void initState() {
    super.initState();
    //print("on call");
    //_fetchData(_issueId);
  }
  @override
  Widget build(BuildContext context) {
    if(_isNavigation) {
      _issueId = ModalRoute.of(context)!.settings.arguments as mongodb.ObjectId;
      _isNavigation = false;
      _fetchData(_issueId);
    }
    
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.grey[0],
      ),
      body: SingleChildScrollView(
        child: 
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Container(
                  width: 260,
                  child: Column(
                    children: [
                      TextField(
                              style: const TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500
                            ),
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines:3,
                            decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                          onTap: () {
                            setState(() {
                              if(_isFirstClick) {
                                _isVisible = !_isVisible;
                                _isFirstClick = !_isFirstClick;
                              }
                            });
                          },
                          controller: _issueNameController,
                          onChanged: (value) {
                          
                            _issueNameController.text = value;
                            _issueNameController.selection = TextSelection.collapsed(offset: _issueNameController.text.length); 
                          },  
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: _isVisible,
                              child: TextButton(
                                child:const Text("CANCEL"),
                                onPressed: (){
                                  FocusScope.of(context).requestFocus( FocusNode());
                                  setState(() {
                                    _isVisible = !_isVisible;
                                    _isFirstClick = !_isFirstClick;
                                    _issueNameController.text = "";
                                  });
                                },)
                            ),
                            Visibility(
                              visible: _isVisible,
                              child: TextButton(
                                child:const Text("SAVE"),
                                onPressed: (){
                                  FocusScope.of(context).requestFocus( FocusNode());
                                  setState(() {
                                    _isVisible = !_isVisible;
                                    _isFirstClick = !_isFirstClick;
                                    MongoDatabase.updateIssue(_issueId, 'name', _issueNameController.text);
                                  });
                                },)
                            )
                          ],
                        ),
              
                    ],
                  )
                  ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 60),
                child: Row(
                  children: [
                    Container(
                      margin:const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: _status.color) ,
                        onPressed: (){
                          showModalBottomSheet(context: context, builder:(context) {
                            return Column(
                              children: [
                                bottomSheetItem(IssueStatusType.toDo, "TO DO", backgroundStatus[IssueStatusType.toDo]!),
                                bottomSheetItem(IssueStatusType.inProgress, "IN PROGRESS", backgroundStatus[IssueStatusType.inProgress]!),
                                bottomSheetItem(IssueStatusType.done, "DONE", backgroundStatus[IssueStatusType.done]!)
                              ],
                            );
                          });
                        },
                        child:  Text(
                          _status.data,
                          style:const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)) ),
                        ),
                    ),
                  const Flexible(
                    //show time this task done
                    child: Text(
                      "",
                      style: TextStyle(fontWeight: FontWeight.w100),
                      maxLines: 2,
                    ),
                  )
                  ],
                ),
              ),
              const Divider(
                indent: 0,
                endIndent: 15,
                color:Color.fromARGB(120, 0, 0, 0),
                thickness:2.0,
                ),
              label("Parent issue"),
              issueType(Icons.assignment_outlined, _epicName,const  Color.fromARGB(237, 239, 19, 206)),
              label("Issue type"),
              issueType(Icons.domain_verification, "Task",const Color.fromARGB(255, 30, 213, 241)),
              label("Sprint"),
              Text(
              _sprintName
              ),
              label("Assignee"),
              Row(
                
                children: [
                  InkWell(
                    child:  Column(
                      children: [
                        
                        issueType(Icons.portrait_rounded, _assigneeName,const  Color.fromARGB(217, 132, 1, 239)),
                      ],
                    ),
                    onTap: () {
                        showModalBottomSheet(context: context, builder: (context) {
                          return Container(
                            margin: EdgeInsets.all(8),
                            child: ListView.builder(
                              padding:const EdgeInsets.only(top: 10, bottom: 10),
                              shrinkWrap: true,
                              itemCount: _listMemberUser.length,
                              itemBuilder:((context, index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                     InkWell(
                                  child: Text(_listMemberUser[index],
                                    style:const TextStyle(fontSize: 25)),
                                  onTap: () {
                                    setState(() {
                                      _assigneeName = _listMemberUser[index];
                                      MongoDatabase.updateIssue(_issueId, 'assignee', _listMemberId[index]);
                                      Navigator.pop(context);
                                    });
                                  },
                                )
                                  ],
                                );
                              }) ),
                          );
                        });
                    },
                  ),
                ],
              ),
              ],
            ),
          ),
      ),
    );
  }

  //Widget item in bottom sheet 
  ListTile bottomSheetItem(IssueStatusType type, String data, Color color )
    => ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color,
              borderRadius:const BorderRadius.all(Radius.circular(10.0))),
            child: Text(data,
              style: const TextStyle( color:  Color.fromARGB(255, 255, 255, 255))),
          ),
        ],
      ),
      onTap: () {
        setState(() {
            _setStatus(type);
        });
      }, 
    );
  //onTap item in bottom sheet
  void _setStatus(IssueStatusType type) {
    Navigator.pop(context);
    switch(type) {
      case IssueStatusType.toDo:
        _status = setStatus("TO DO");
        MongoDatabase.updateIssue(_issueId, 'status', "TO DO");
        break;
      case IssueStatusType.inProgress:
        _status = setStatus("IN PROGRESS");
        MongoDatabase.updateIssue(_issueId, 'status', "IN PROGRESS");
        break;
      case IssueStatusType.done: 
        _status = setStatus("DONE");
        MongoDatabase.updateIssue(_issueId, 'status', "DONE");
        break;
    }
  }
}
