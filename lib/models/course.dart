enum CourseType {
  video,
  online,
  physical,
  pdf,
}

class Course {
  final String id;
  final String title;
  final String description;
  final double price;
  final CourseType type;
  final String instructor;
  final String duration;
  final String image;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    required this.instructor,
    required this.duration,
    required this.image,
  });
}