class Question {
  final int id;
  final String questions;
  final String category;
  final List<String> options;
  final int answer;
  final String? description;

  Question({
    required this.category,
    required this.id,
    required this.questions,
    required this.options,
    required this.answer,
    this.description,
});

  Map<String, dynamic> toJson () {
    return {
      "category" : category,
      "id" : id,
      "questions" : questions,
      "options" : options,
      "answer" : answer,
      "description": description ?? '',  // ถ้า description เป็น null ให้ใช้ค่า default
    };
  }


  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      category: json["category"] ?? '',  // ถ้าไม่มีให้ใช้ค่าว่าง
      id: json["id"] ?? 0,  // ถ้าไม่มีให้ใช้ 0
      questions: json["questions"] ?? '',  // ถ้าไม่มีให้ใช้ค่าว่าง
      options: json["options"] != null
          ? List<String>.from(json["options"])  // ถ้ามี options ให้แปลงเป็น List
          : [],  // ถ้าไม่มีให้ใช้ลิสต์ว่าง
      answer: json["answer"] ?? 0,  // ถ้าไม่มีให้ใช้ 0
      description: json["description"] ?? '',  // ถ้าไม่มีให้ใช้ค่าว่าง
    );
  }



}