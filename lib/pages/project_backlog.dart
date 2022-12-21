import 'package:flutter/material.dart';

class BacklogTab extends StatefulWidget {
  const BacklogTab({super.key});

  @override
  State<BacklogTab> createState() => _BacklogTabBuilder();
}

class _BacklogTabBuilder extends State<BacklogTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          ExpansionTile(
            title: Text('Sprint 1 (active)'),
            subtitle: Text('4 issues'),
            controlAffinity: ListTileControlAffinity.leading,
            children: <Widget>[
              ListTile(
                title: Text('Task 1.1'),
                leading: Icon(Icons.task),
                trailing: Icon(Icons.assignment_ind_outlined),
                // onTap: () {},
              ),
              ListTile(
                title: Text('Task 1.2'),
                leading: Icon(Icons.task),
                trailing: Icon(Icons.assignment_ind_outlined),
                // onTap: () {},
              ),
              ListTile(
                title: Text('Bug 1'),
                leading: Icon(Icons.bug_report),
                trailing: Icon(Icons.assignment_ind_outlined),
                // onTap: () {},
              ),
              ListTile(
                title: Text('Story 1'),
                leading: Icon(Icons.amp_stories_rounded),
                trailing: Icon(Icons.assignment_ind_outlined),
                // onTap: () {},
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Sprint 2'),
            subtitle: Text('2 issues'),
            controlAffinity: ListTileControlAffinity.leading,
            children: <Widget>[
              ListTile(
                title: Text('Task 2'),
                leading: Icon(Icons.task),
                trailing: Icon(Icons.assignment_ind_outlined),
                // onTap: () {},
              ),
              ListTile(
                title: Text('Bug 2'),
                leading: Icon(Icons.bug_report),
                trailing: Icon(Icons.assignment_ind_outlined),
                // onTap: () {},
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Sprint 1 (active)'),
            subtitle: Text('4 issues'),
            controlAffinity: ListTileControlAffinity.leading,
            children: <Widget>[
              ListTile(
                title: Text('Task 1.1'),
                leading: Icon(Icons.task),
                trailing: Icon(Icons.assignment_ind_outlined),
                // onTap: () {},
              ),
              ListTile(
                title: Text('Task 1.2'),
                leading: Icon(Icons.task),
                trailing: Icon(Icons.assignment_ind_outlined),
                // onTap: () {},
              ),
              ListTile(
                title: Text('Bug 1'),
                leading: Icon(Icons.bug_report),
                trailing: Icon(Icons.assignment_ind_outlined),
                // onTap: () {},
              ),
              ListTile(
                title: Text('Story 1'),
                leading: Icon(Icons.amp_stories_rounded),
                trailing: Icon(Icons.assignment_ind_outlined),
                // onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
