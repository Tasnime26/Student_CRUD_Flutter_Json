import 'package:flutter/material.dart';
import 'package:flutter_json/Students.dart';
import 'package:flutter_json/StudentListWidget.dart';
import 'package:flutter_json/add_student_page.dart';
void main() => runApp(StaticApp());

class StaticApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     // home: ImmutableWidget(),
     home: StudentListWidget(),
     routes: {
        '/add_student': (context) => AddStudentPage(), // Define the route for AddStudentPage
      },
    );
  }
}
