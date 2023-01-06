import 'package:flutter/material.dart';
import 'package:jira_mobile/dbhelper/mongodb.dart';
import 'package:jira_mobile/epic_issue_page_component/class_status.dart';
import 'package:jira_mobile/epic_issue_page_component/component.dart';
import 'package:intl/intl.dart';
import 'package:expandable/expandable.dart';
import 'package:jira_mobile/pages/issue_page.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongodb;
class EpicPage extends StatefulWidget {
  const EpicPage({super.key});

  @override
  State<EpicPage> createState() => _EpicPageState();
}

class _EpicPageState extends State<EpicPage> {
  mongodb.ObjectId _epicId = mongodb.ObjectId.fromHexString("63a483eedacce779a339b1a8");
  bool _isNavigation = true;
  //name epic 
 //handle text field event
  bool _isVisible = false;
  bool _isFirstClick = true;
  final TextEditingController _issueNameController = TextEditingController(text: "");

  //issue status
  Status _status =setStatus("TO DO");
  

  //datatime pickup
  /*
  true - start
  false - end
  */
  bool __isStartOrEnd = true;
  String _startDay = '';
  String _endDay = '';

  //child issue
  var list = <String>[];
  var listId = <mongodb.ObjectId>[];
  /*when user click create child issue make create disappear 
  and text file appear*/
  bool _isVisible2 = true;
  String newChildIssueName = "";

  //assignee
  String _assigneeName = "Unassigned";
  var _listMemberId = <mongodb.ObjectId>[];
  var _listMemberUser = <String>[];
  
  void _fetchData(mongodb.ObjectId id) {
    Future<Map<String,dynamic>> epic = MongoDatabase.getEpic(id);
    epic.then((epicData) {
        setState(() {
        //print("epic data is: ${epicData.toString()}");

        _issueNameController.text = epicData['name'];
        _status = setStatus(epicData['status']);
        _startDay = epicData['start_date'];
        _endDay = epicData['due_date'];
        Future<Map<String,dynamic>?> project = MongoDatabase.getProjectMemberIdByEpic(epicData['project_id']);
        project.then((projectData) {
          //print("project data is ${projectData.toString()}");
          if(projectData != null) {
            for(int i = 0; i < projectData['members'].length; i++) {
                _listMemberId.add(projectData['members'][i] as mongodb.ObjectId);
            }
            
            MongoDatabase.getListMemberInProject(_listMemberId).then((value) {
                //print("list member is : ${value.toString()}");

                for (int i = 0; i < value.length; i++){
                  _listMemberUser.add(value[i]['name']);
                  if(value[i]['_id'] == epicData['assignee']) {
                    _assigneeName = value[i]['name'];
                  }
                }
            });  
          }
        });

        });
    });

    Future<Map<String,dynamic>?> epicIssue = MongoDatabase.getEpicIssues(id);
    epicIssue.then((value) {
      if(value != null) {
        //print("list child issue is: ${value.toString()}");
        for (int i = 0; i < value['issues'].length; i ++){
          listId.add(value['issues'][i]);
          Future<Map<String,dynamic>> issue = MongoDatabase.getIssue(listId[i]);
          issue.then((value) {
            setState(() {
              list.add(value['name']);
            });
          } );
        }
      }
    }
    );
  }
  @override
  void initState()  {
    super.initState();
    //_fetchData(_epicId);
  }
  @override
  Widget build(BuildContext context) {
    if(_isNavigation) {
      _epicId = ModalRoute.of(context)!.settings.arguments as mongodb.ObjectId;
      _isNavigation = false;
      _fetchData(_epicId);
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
                SizedBox(
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
                                    MongoDatabase.updateEpic(_epicId, 'name', _issueNameController.text);
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

                  // const Flexible(
                  //   child: Text(
                  //     "done in 5 day and 6 hours ",
                  //     style: TextStyle(fontWeight: FontWeight.w100),
                  //     maxLines: 2,
                  //   ),
                  // )

                  ],
                ),
              ),
              const Divider(
                indent: 0,
                endIndent: 15,
                color:Color.fromARGB(120, 0, 0, 0),
                thickness:2.0,
                ),
              ExpandablePanel(
                header: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    label("Child issue"),
                    Text("${list.length}")]),

                collapsed: const Text(""), 
                expanded: Column(
                  children: [
                    _listChildIssue(),
                    _createChildIssueButton()
              ],
                ),),
              //issueType(Icons.assignment_outlined, "epic 1",const  Color.fromARGB(237, 239, 19, 206)),
              label("Issue type"),
              issueType(Icons.assignment_outlined, "Epic",const  Color.fromARGB(237, 239, 19, 206)),
              pickupDateWidget("Start day", _startDay),
              pickupDateWidget("Due day", _endDay),
              label("Assignee"),
              Row(
                mainAxisSize: MainAxisSize.max,
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
                                      MongoDatabase.updateEpic(_epicId, 'assignee', _listMemberId[index]);
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
        MongoDatabase.updateEpic(_epicId, 'status', "TO DO");
        break;
      case IssueStatusType.inProgress:
        _status = setStatus("IN PROGRESS");
        MongoDatabase.updateEpic(_epicId, 'status', "IN PROGRESS");
        break;
      case IssueStatusType.done: 
        _status = setStatus("DONE");
        MongoDatabase.updateEpic(_epicId, 'status', "DONE");
        break;
    }
  }

  //pick up date 
  Widget pickupDateWidget(String typeOfPick, String dateTime) {
      return  InkWell(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        label(typeOfPick),
                        Text(dateTime)
                      ],
                    ),
                  ],
                ),
                onTap:() {
                  if(typeOfPick == "Start day") {
                    __isStartOrEnd = true;
                  }else {
                    __isStartOrEnd = false;
                  }
                  _pickUpDate();
                }
              );
  }
  
  void _pickUpDate() {
    showDatePicker(context: context, 
    initialDate: DateTime.now(), 
    firstDate: DateTime(2000), 
    lastDate: DateTime(3000)).then((value) {
      setState(() {

        if(value == null) return;
        String day = DateFormat('dd-MM-yyyy').format(value).toString();
        if(__isStartOrEnd) {
          _startDay = day;
          MongoDatabase.updateEpic(_epicId, 'start_date', _startDay);
        }else {
          _endDay = day;
          MongoDatabase.updateEpic(_epicId, 'due_date', _endDay);
        }
      });
    }) ;
  }

  Widget _listChildIssue() {
    return 
       ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder:(context) {
                  return const IssuePage();
                },
                settings: RouteSettings(arguments: listId[index])),);
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Text(list[index]),
            ));
      });
  }

  Widget _createChildIssueButton() {
    return Column(
      children: [
        Visibility(
          visible: _isVisible2,
          child:                    
            TextButton(
              onPressed: (){
                setState(() {
                  _isVisible2 = !_isVisible2;
                });
              }, 
              child: Row(
                children:const [
                  Icon(Icons.add),
                    Text("Create")
                  ]
                ),
              ),
            ),
        Visibility(
          visible: !_isVisible2,
          child: Column(
            children: [
              TextField(
                decoration:const InputDecoration(
                  border: UnderlineInputBorder()
                ),
                onChanged: (newName) {
                    newChildIssueName = newName;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: (){
                      FocusScope.of(context).requestFocus( FocusNode());
                      setState(() {
                        _isVisible2 = !_isVisible2;
                      });
                    }, 
                    child: const Text("CANCEL")
                  ),
                  TextButton(
                    onPressed: (){
                      FocusScope.of(context).requestFocus( FocusNode());
                      setState(() {
                        _isVisible2 = !_isVisible2;
                        list.add(newChildIssueName);
                        listId.add(mongodb.ObjectId.fromSeconds(DateTime.now().microsecondsSinceEpoch));
                        MongoDatabase.insertChildissue(_epicId, listId, newChildIssueName);
                      });
                    }, 
                    child: const Text("OK")
                  ),
                ],
              )
            ],
          ))    
          ],
        );
      } 
}
