import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_json/Students.dart';

import 'package:flutter_json/edit_course_page.dart';

class EditStudentPage extends StatefulWidget {
  final Student student;

  EditStudentPage({required this.student});

  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    // i Initialized the controllers with the existing values
    firstNameController.text = widget.student.firstName;
    lastNameController.text = widget.student.lastName;
    emailController.text = widget.student.email;
    phoneController.text = widget.student.phone;
    addressController.text = widget.student.address;
    birthdateController.text = widget.student.birthdate;
    courses.addAll(widget.student.courses.cast<Course>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student'),
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
              DataTable(
                columns: [
                  DataColumn(label: Text('Course Name')),
                  DataColumn(label: Text('Grade')),
                  DataColumn(label: Text('Edit')),
                ],
                rows: courses.asMap().entries.map<DataRow>((entry) {
                  int index = entry.key;
                  Course course = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(course.courseName)),
                      DataCell(Text(course.grade)),
                      DataCell(
                        ElevatedButton(
                          onPressed: () {
                            _editCourse(index);
                          },
                          child: Text('Edit'),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  updateStudent(
                    widget.student.id,
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
                child: Text('Update Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editCourse(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCoursePage(course: courses[index]),
      ),
    ).then((editedCourse) {
      if (editedCourse != null) {
        setState(() {
          courses[index] = editedCourse;
        });
      }
    });
  }

  void updateStudent(
    int studentId,
    String firstName,
    String lastName,
    String email,
    String phone,
    String address,
    String birthdate,
    List<Course> courses,
  ) async {
    String apiUrl = "http://192.168.56.1:3004/students/$studentId";

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
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print('Student updated successfully.');
      } else {
        print('Failed to update student. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
