import 'package:contentpagecmmapp/controllers/question_controller.dart';
import 'package:contentpagecmmapp/models/questions_model.dart';
import 'package:contentpagecmmapp/views/quiz/option_quiz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/constants.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    QuestionController questionController = Get.put(QuestionController());
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kPadding),
      padding: EdgeInsets.all(kPadding),
      child: Column(
          children: [
          Text(
          question.questions,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: kBlackColor,
            ),
      ),
      const SizedBox(height: kPadding / 2,),
      ...List.generate(question.options.length, (index) => OptionQuiz(text: question.options[index], index: index, press: () => questionController.checkAns(question, index)))
      ],
      ),
    );
  }
}
