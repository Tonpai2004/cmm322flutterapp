import 'package:contentpagecmmapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/question_controller.dart';
import '../../models/questions_model.dart';

class CheckfaultCard extends StatelessWidget {
  final Question question;
  const CheckfaultCard({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {

    // ใช้ questionController เพื่อดึงข้อมูลคำถามและลำดับคำถาม
    QuestionController questionController = Get.put(QuestionController());

    // คำนวณลำดับของคำถาม
    int questionIndex = questionController.filteredQuestion.indexOf(question) + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // กล่อง: คุณตอบไม่ถูกต้อง
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF4CD1C2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.help_outline, color: Colors.white, size: 30),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Explanation of question $questionIndex",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // กล่องคำถาม
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFCFFFFA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(question.questions, style: const TextStyle(fontSize: 18)),
        ),

        const SizedBox(height: 16),

        // กล่องคำเฉลย
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF4CD1C2),
            border: Border.all(color: Colors.teal, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text.rich(
            TextSpan(
              text: 'Answer: ', // ข้อความก่อนตัวเลือกคำตอบ
              style: const TextStyle(fontSize: 16, color: Colors.white), // สีขาวสำหรับข้อความก่อนคำตอบ
              children: [
                TextSpan(
                  text: '${question.options[question.answer]}', // ตัวเลือกคำตอบ
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, // ตัวหนา
                  ),
                ),
                TextSpan(
                  text: '\n${question.description ?? ''}', // คำอธิบาย
                  style: const TextStyle(fontSize: 16, color: Colors.white), // สีขาวสำหรับคำอธิบาย
                ),
              ],
            ),
          ),
        )

      ],
    );
  }
}
