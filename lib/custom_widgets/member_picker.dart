import 'package:flutter/material.dart';
import 'package:jira_mobile/custom_widgets/member_card.dart';

import '../objects/user.dart';

class MemberPickerWidget extends StatefulWidget {
  List<User> users;
  MemberPickerWidget({Key? key, required this.users}) : super(key: key);

  @override
  _MemberPickerWidgetState createState() => _MemberPickerWidgetState();
}

class _MemberPickerWidgetState extends State<MemberPickerWidget> {
  User? pickedUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var user in widget.users) MemberCardWidget(user: user, callback: select)
            ],
          ),
        ),
      ),
    );
  }

  void select(User user) {
    pickedUser = user;
    Navigator.pop(context, pickedUser);
  }
}
