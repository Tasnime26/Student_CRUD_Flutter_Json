import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_json/Students.dart';
class AddStudentPage extends StatefulWidget {
  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final List<Course> courses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: birthdateController,
                decoration: InputDecoration(labelText: 'Birthdate'),
              ),
              Text('Courses:'),
              ElevatedButton(
                onPressed: () {
                  _addCourse();
                },
                child: Text('Add Course'),
              ),
              DataTable(
                columns: [
                  DataColumn(label: Text('Course Name')),
                  DataColumn(label: Text('Grade')),
                ],
                rows: courses
                    .map((course) => DataRow(
                          cells: [
                            DataCell(TextField(
                              onChanged: (value) {
                                course.courseName = value;
                              },
                            )),
                            DataCell(TextField(
                              onChanged: (value) {
                                course.grade = value;
                              },
                            )),
                          ],
                        ))
                    .toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  addStudent(
                    firstNameController.text,
                    lastNameController.text,
                    emailController.text,
                    phoneController.text,
                    addressController.text,
                    birthdateController.text,
                    courses,
                  );
                  Navigator.pop(context);
                },
                child: Text('Add Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addCourse() {
    setState(() {
      courses.add(Course());
    });
  }


  void addStudent(
    String firstName,
    String lastName,
    String email,
    String phone,
    String address,
    String birthdate,
    List<Course> courses,
  ) async {
    String apiUrl = "http://192.168.56.1:3004/students";

    Map<String, dynamic> studentData = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'birthdate': birthdate,
      'courses': courses.map((course) => course.toJson()).toList(),
    };

    String jsonBody = json.encode(studentData);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );

      if (response.statusCode == 201) {
        print('Student added successfully.');
      } else {
        print('Failed to add student. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

class Course {
  String courseName = '';
  String grade = '';

  Map<String, dynamic> toJson() {
    return {
      'course_name': courseName,
      'grade': grade,
    };
  }
}
