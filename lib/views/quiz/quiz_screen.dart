import 'package:contentpagecmmapp/utils/constants.dart';
import 'package:contentpagecmmapp/views/quiz/body_quiz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:contentpagecmmapp/controllers/question_controller.dart';
import '../main/homepage.dart';
import '../main/navbar.dart';
import '../main/footer.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _isMenuOpen = false;
  bool isLoggedIn = false;

  QuestionController questionController = Get.put(QuestionController());

  @override
  void initState() {
    super.initState();
    // Set the filtered questions based on the category
    questionController.setFilteredQuestions(widget.category);
    print('setFilteredQuestions');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Responsive Navbar
              ResponsiveNavbar(
                isMobile: isMobile,
                isMenuOpen: _isMenuOpen,
                toggleMenu: () => setState(() => _isMenuOpen = !_isMenuOpen),
                goToHome: () {
                  setState(() => _isMenuOpen = false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                onMyCourses: () {},
                onSupport: () {},
                onLogin: () {},
                onRegister: () {}, isLoggedIn: isLoggedIn,
              ),

              // Use GetX to listen to changes in filteredQuestion
              GetX<QuestionController>(
                builder: (controller) {
                  // Check if filteredQuestion is empty
                  if (controller.filteredQuestion.isEmpty) {
                    return Center(child: Text("No questions available for this category."));
                  }

                  // BodyQuiz that will handle multiple content components
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: BodyQuiz(category: widget.category),
                  );
                },
              ),

              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
