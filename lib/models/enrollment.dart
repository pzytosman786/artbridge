class Enrollment {
  final String id;
  final String userId;
  final String courseId;
  bool isCompleted;
  double progress;

  Enrollment({
    required this.id,
    required this.userId,
    required this.courseId,
    this.isCompleted = false,
    this.progress = 0,
  });

  factory Enrollment.fromFirestore(
    String documentId,
    Map<String, dynamic> data,
  ) {
    return Enrollment(
      id: documentId,
      userId: data['userId']?.toString() ?? '',
      courseId: data['courseId']?.toString() ?? '',
      isCompleted: data['isCompleted'] == true,
      progress: (data['progress'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'courseId': courseId,
      'isCompleted': isCompleted,
      'progress': progress,
    };
  }
}