import 'package:flutter/material.dart';

//widget to display in issue type and epic 
Row issueType(IconData icon, String type, Color color) 
=> Row(
  mainAxisSize: MainAxisSize.min,
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Icon(icon, color: color,),
    Container(
      margin:const  EdgeInsets.only(left: 10),
      child: Text(type,),
    )
  ],
);

//widget to display label iny epic/issue screen
Container label(String label) 
=> Container(
    margin:const EdgeInsets.only(top: 20, bottom: 20),
    child: 
      Text(label,
        style: const TextStyle(
        fontWeight: FontWeight.w200
    ),
  ),
);
