class ProgressModel {
  String studentId;
  String lessonId;
  double progress;

  ProgressModel({
    required this.studentId,
    required this.lessonId,
    required this.progress,
  });

  // Convert object to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'lessonId': lessonId,
      'progress': progress,
    };
  }

  // Convert map to object from Firestore
  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      studentId: map['studentId'] ?? '',
      lessonId: map['lessonId'] ?? '',
      progress: map['progress'] ?? 0.0,
    );
  }
}
