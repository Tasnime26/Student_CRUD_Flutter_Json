class Student {
  final int id;
  final String firstName;
  final String lastName;
  final String birthdate;
  final String email;
  final String phone;
  final String address;
  final List<Course> courses;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.email,
    required this.phone,
    required this.address,
    List<Course>? courses, // Make courses an optional parameter
  }) : courses = courses ?? []; // i Initialized courses to an empty list if not provided

  factory Student.fromJson(Map<String, dynamic> json) {
    List<dynamic> courseData = json['courses'];
    List<Course> studentCourses =
        courseData.map((course) => Course.fromJson(course)).toList();

    return Student(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthdate: json['birthdate'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      courses: studentCourses,
    );
  }
}


/*class Course {
  final int courseId;
  final String courseName;
  final String grade;

  Course({
    required this.courseId,
    required this.courseName,
    required this.grade,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['id'],
      courseName: json['course_name'],
      grade: json['grade'],
    );
  }
}*/
class Course {
  final String courseName;
  final String grade;

  Course({
    required this.courseName,
    required this.grade,
  });

  Map<String, dynamic> toJson() {
    return {
      'course_name': courseName,
      'grade': grade,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseName: json['course_name'],
      grade: json['grade'],
    );
  }
}


class UniqueIdGenerator {
  static int _lastId = 0;

  static int generateUniqueId() {
    _lastId++;
    return _lastId;
  }
}
