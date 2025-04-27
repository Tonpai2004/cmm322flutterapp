import 'dart:async';

import 'package:contentpagecmmapp/utils/constants.dart';
import 'package:contentpagecmmapp/views/quiz/question_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/question_controller.dart';

class BodyQuiz extends StatefulWidget {
  final String category;
  const BodyQuiz({super.key, required this.category});

  @override
  State<BodyQuiz> createState() => _BodyQuizState();
}

class _BodyQuizState extends State<BodyQuiz> {
  Timer? _timer;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    startTimer();  // Start the timer when the page is opened

    Get.find<QuestionController>().selectedCategory = widget.category;
  }

  void startTimer() {
    if (_isTimerRunning) return;

    _isTimerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        Get.find<QuestionController>().incrementTime();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    QuestionController questionController = Get.find();

    PageController pageController = questionController.pageController;

    // Get total number of questions
    int totalQuestions = questionController.filteredQuestion.length;


    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Color
        Container(
          color: kBackground, // ตั้งค่า backgroundColor ให้เป็น kBackground
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ), // Padding ที่ต้องการ
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Row สำหรับ header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.category,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: kDarkSecondaryColor,
                      ),
                    ),
                    // Timer Display
                    // Timer Display, Align the timer vertically centered
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        formatTime(questionController.seconds.value),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: kDarkPrimaryColor, // Adjust color as needed
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 12,
                ),

                // Row สำหรับ header with question text and progress bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Question number and total questions text aligned left
                    Obx(() => Text(
                      "${questionController.questionNumber.value}/$totalQuestions",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: kDarkSecondaryColor, // Color for the text
                      ),
                    )),

                    Obx(() {
                      double progress = totalQuestions > 0
                          ? questionController.questionNumber.value / totalQuestions
                          : 0.0;

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: kLightPrimaryColor,
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: kDarkSecondaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    })

                  ],
                ),


                // PageView.builder สำหรับแสดงคำถาม
                Expanded(
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: questionController.updateTheQnNum,
                    itemCount: questionController.filteredQuestion.length,
                    controller: pageController,
                    itemBuilder: (context, index) {
                      return QuestionCard(
                        question: questionController.filteredQuestion[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
