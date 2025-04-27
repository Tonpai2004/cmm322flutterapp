import 'package:contentpagecmmapp/controllers/question_controller.dart';
import 'package:contentpagecmmapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../main/homepage.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง ลิงก์หน้าHome มาจากไฟล์นี้ //
import '../main/maincontent_video.dart';
import '../main/navbar.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง Navbar มาจากไฟล์นี้ //
import '../main/footer.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง Footer มาจากไฟล์นี้ //
import 'checkfault_screen.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {

  late int _seconds;
  late String _category;


  // เอาไว้เช็คค่าสถานะว่าแท็บ Menu ได้เปิดไปหรือไม่ อย่าลืมเอาไปใส่ด้วย //
  bool _isMenuOpen = false;
  bool isLoggedIn = false;

  QuestionController questionController = Get.put(QuestionController());

  @override
  void initState() {
    super.initState();

    final arguments = Get.arguments as Map<String, dynamic>?;
    _seconds = arguments?['time'] ?? 0;
    _category = arguments?['category'] ?? 'Unknown';
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }


  @override
  Widget build(BuildContext context) {
    // 2อันนี้เอาไว้วัดขนาดหน้าจอ อย่าลืมเอาไปใส่ในไฟล์ด้วย จะได้ Responsive menu ของ Navbar ได้ถูกต้อง //
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;


    // Get total number of questions
    int totalQuestions = questionController.filteredQuestion.length;

    String categoryN = _category.split(':')[1].trim().split(' ')[0];
    int categoryInt = int.tryParse(categoryN) ?? 0;
    int currentIndex = categoryInt;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
        child: Column(
          children: [
            // Navbar
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


                  // Background
                  Container(color: kBackground),

                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _category,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: kDarkSecondaryColor,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  formatTime(_seconds),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: kDarkPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Progress bar and question counter
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() => Text(
                                "${questionController.questionNumber.value}/$totalQuestions",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: kDarkSecondaryColor,
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
                                        color: kLightPrimaryColor.withOpacity(0.8),
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

                        ],
                      ),
                    ),
                  ),


            const SizedBox(height: 30),

            // Result Text
            const Text(
              "You scored",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color:  Color(0xFF212D61),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${questionController.numOfCorrectAns}/5 points",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color:  Color(0xFF212D61),
              ),
            ),
            const SizedBox(height: 16),
            Text(
                "Time spent : " + formatTime(_seconds),
              style: TextStyle(
                fontSize: 18,
                color:  Color(0xFF212D61),
              ),
            ),

            const SizedBox(height: 30),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.7, // Set to 20% of the screen width
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(CheckfaultScreen(
                          category: _category, seconds: _seconds, currentIndex: currentIndex
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kDarkPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16), // Horizontal padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5, // Shadow effect
                      ),
                      child: const Text(
                        "Review incorrect",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FractionallySizedBox(
                    widthFactor: 0.7, // Set to 20% of the screen width
                    child: ElevatedButton(
                      onPressed: currentIndex > 0
                          ? () => navigateToVideo(currentIndex + 1, currentIndex)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kDarkPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16), // Horizontal padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5, // Shadow effect
                      ),
                      child: const Text(
                        "Next lesson",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            const SizedBox(height: 30),

            // Learning Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "% Learning Progress",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212D61),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: categoryInt/4.0,
                    backgroundColor: Colors.teal.shade100,
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "*Keep going!! Don’t give up yet\nYou've made it past $categoryN/4 of the content",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF3FA099),
                        fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Footer
            const Footer(),
          ],
        ),
        ),
      ),
    );


  }

  void navigateToVideo(int newIndex, int currentIndex) {
    final video = videoList[newIndex];
    final isNext = newIndex > currentIndex;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return MainContentVideoPage(
            videoTitle: video.title,
            videoUrl: video.url,
            chapter: video.chapter,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const beginLeft = Offset(1.0, 0.0);   // จากขวาไปซ้าย
          const end = Offset.zero;

          const beginRight = Offset(-1.0, 0.0); // จากซ้ายไปขวา
          final tween = Tween<Offset>(begin: isNext ? beginLeft : beginRight, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

}
