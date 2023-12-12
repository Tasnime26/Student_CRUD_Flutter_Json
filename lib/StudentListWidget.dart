import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_json/EditStudentPage.dart';
import 'package:flutter_json/Students.dart';

class StudentListWidget extends StatefulWidget {
  @override
  _StudentListWidgetState createState() => _StudentListWidgetState();
}

class _StudentListWidgetState extends State<StudentListWidget> {
  late Future<List<Student>> _students;
  List<Student> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
    _students = fetchStudents();
  }

  Future<void> _refreshStudentList() async {
    setState(() {
      _students = fetchStudents();
      _filteredStudents = [];
    });
  }

  Future<List<Student>> fetchStudents() async {
    final response = await http.get(Uri.parse('http://192.168.56.1:3004/students'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Student> students = data.map((item) => Student.fromJson(item)).toList();
      return students;
    } else {
      throw Exception('Failed to load students');
    }
  }

  List<Student> filterStudentsByBirthYear(List<Student> students, int birthYear) {
    return students.where((student) {
      DateTime studentBirthdate = DateTime.parse(student.birthdate);
      return studentBirthdate.year == birthYear;
    }).toList();
  }

  void _showFilterDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Drawer(
          child: Column(
            children: [
              AppBar(
                title: Text('Filter Options'),
                automaticallyImplyLeading: false,
              ),
              ListTile(
                title: Text('Filter by Birth Year'),
                onTap: () {
                  Navigator.pop(context);
                  _showFilterDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Birth Year'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) async {
              int birthYear = int.tryParse(value) ?? 0;
              List<Student> students = await _students;
              setState(() {
                _filteredStudents = filterStudentsByBirthYear(students, birthYear);
              });
            },
            decoration: InputDecoration(
              labelText: 'Enter Birth Year',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _filteredStudents = [];
                });
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editStudent(Student student) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditStudentPage(student: student)),
    );
    await _refreshStudentList();
  }

  void _deleteStudent(int studentId) async {
    final response = await http.delete(Uri.parse('http://192.168.56.1:3004/students/$studentId'));

    if (response.statusCode == 200) {
      print('Student deleted successfully.');
      await _refreshStudentList();
    } else {
      print('Failed to delete student. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Student List'),
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                _showFilterDrawer(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                await Navigator.pushNamed(context, '/add_student');
                await _refreshStudentList();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Card(
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2), 
                },
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Address and Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Courses and Grades',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Actions',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshStudentList,
                child: FutureBuilder<List<Student>>(
                  future: _students,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<Student> students = snapshot.data ?? [];
                      if (students.isEmpty) {
                        return Center(child: Text('No students found.'));
                      }

                      List<Student> displayedStudents = _filteredStudents.isNotEmpty ? _filteredStudents : students;

                      return ListView.builder(
                        itemCount: displayedStudents.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Table(
                              columnWidths: {
                                0: FlexColumnWidth(2), 
                                1: FlexColumnWidth(2),
                                2: FlexColumnWidth(2),
                                3: FlexColumnWidth(2),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${displayedStudents[index].firstName} ${displayedStudents[index].lastName}',
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Email: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text('${displayedStudents[index].email}'),
                                            Text(
                                              'Address: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text('${displayedStudents[index].address}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: displayedStudents[index].courses.map((course) {
                                            return Text('Course: ${course.courseName}, Grade: ${course.grade}');
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              _editStudent(displayedStudents[index]);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              _deleteStudent(displayedStudents[index].id);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
