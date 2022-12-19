import 'package:flutter/material.dart';
import 'package:jira_mobile/epic_issue_page_component/class_status.dart';
import 'package:jira_mobile/epic_issue_page_component/component.dart';
import 'package:intl/intl.dart';
import 'package:expandable/expandable.dart';
class EpicPage extends StatefulWidget {
  const EpicPage({super.key});

  @override
  State<EpicPage> createState() => _EpicPageState();
}

class _EpicPageState extends State<EpicPage> {
 //handle text field event
  bool _isVisible = false;
  bool _isFirstClick = true;
  final TextEditingController _issueNameController = TextEditingController(text: "");

  //issue status
  Status _status = Status(IssueStatusType.toDo, "TO DO",backgroundStatus[IssueStatusType.toDo]!);
  //datatime pichup
  /*
  true - start
  false - end
  */
  bool __isStartOrEnd = true;
  String _startDay = '';
  String _endDay = '';

  //child issue
  var list = <String>[];
  /*when user click create child issue make create disappear 
  and text file appear*/
  bool _isVisible2 = true;
  String newChildIssue = "";
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
        }else {
          _endDay = day;
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
            onTap: (){},
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
                    newChildIssue = newName;
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
                        list.add(newChildIssue);
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