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
  //handle text field event
  bool _isVisible = false;
  bool _isFirstClick = true;
  final TextEditingController _issueNameController = TextEditingController(text: "");

  //issue status
  Status _status = Status(IssueStatusType.toDo, "TO DO",backgroundStatus[IssueStatusType.toDo]!);

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                    child: Text(
                      "done in 5 day and 6 hours ",
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
              issueType(Icons.assignment_outlined, "epic 1",const  Color.fromARGB(237, 239, 19, 206)),
              label("Issue type"),
              issueType(Icons.domain_verification, "Task",const Color.fromARGB(255, 30, 213, 241)),
              label("Sprint"),
              const Text(
              "Sprint 1"
              ),
              label("Assignee"),
              issueType(Icons.portrait_rounded, "member A",const  Color.fromARGB(217, 132, 1, 239))
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
        _status = Status(IssueStatusType.toDo, "TO DO",backgroundStatus[IssueStatusType.toDo]!);
        break;
      case IssueStatusType.inProgress:
        _status = Status(IssueStatusType.inProgress, "IN PROGRESS",backgroundStatus[IssueStatusType.inProgress]!);
        break;
      case IssueStatusType.done: 
        _status = Status(IssueStatusType.done, "DONE",backgroundStatus[IssueStatusType.done]!);
        break;
    }
  }
}