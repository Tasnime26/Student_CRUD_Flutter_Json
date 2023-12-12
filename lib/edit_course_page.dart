
import 'package:flutter/material.dart';
import 'package:flutter_json/Students.dart';

class EditCoursePage extends StatefulWidget {
  final Course course;

  EditCoursePage({required this.course});

  @override
  _EditCoursePageState createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  late TextEditingController courseNameController;
  late TextEditingController gradeController;

  @override
  void initState() {
    super.initState();
    courseNameController = TextEditingController(text: widget.course.courseName);
    gradeController = TextEditingController(text: widget.course.grade);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: courseNameController,
              decoration: InputDecoration(labelText: 'Course Name'),
            ),
            TextField(
              controller: gradeController,
              decoration: InputDecoration(labelText: 'Grade'),
            ),
            ElevatedButton(
              onPressed: () {
                Course editedCourse = Course(
                  courseName: courseNameController.text,
                  grade: gradeController.text,
                );
                Navigator.pop(context, editedCourse);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
