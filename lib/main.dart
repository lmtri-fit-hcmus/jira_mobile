import 'package:flutter/material.dart';
import 'package:jira_mobile/pages/login_page.dart';

void main() {
  runApp(const JiraMobile());
}

class JiraMobile extends StatelessWidget {
  const JiraMobile({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
