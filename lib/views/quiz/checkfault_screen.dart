import 'package:contentpagecmmapp/views/quiz/checkfault_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controllers/question_controller.dart';
import '../../utils/constants.dart';
import '../main/homepage.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง ลิงก์หน้าHome มาจากไฟล์นี้ //
import '../main/maincontent_video.dart';
import '../main/navbar.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง Navbar มาจากไฟล์นี้ //
import '../main/footer.dart';

class CheckfaultScreen extends StatefulWidget {
  final String category;
  final int seconds;
  final int currentIndex;
  const CheckfaultScreen({
    super.key,
    required this.category,
    required this.seconds, required this.currentIndex,
  });

  @override
  State<CheckfaultScreen> createState() => _CheckfaultScreenState();
}

class _CheckfaultScreenState extends State<CheckfaultScreen> {
  // เอาไว้เช็คค่าสถานะว่าแท็บ Menu ได้เปิดไปหรือไม่ อย่าลืมเอาไปใส่ด้วย //
  bool _isMenuOpen = false;
  bool isLoggedIn = false;

  QuestionController questionController = Get.put(QuestionController());

  late final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose(); // dispose page controller ด้วย
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  // ฟังก์ชั่นสำหรับแสดง dialog หรือเปลี่ยนหน้าเมื่อคำถามหมด
  void showNextLessonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Completed Question'),
          content: const Text(
            'Do you want to go to the next lesson?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: widget.currentIndex > 0
                  ? () => navigateToVideo(widget.currentIndex + 1, widget.currentIndex)
                  : null,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 2อันนี้เอาไว้วัดขนาดหน้าจอ อย่าลืมเอาไปใส่ในไฟล์ด้วย จะได้ Responsive menu ของ Navbar ได้ถูกต้อง //
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    // Get total number of questions
    int totalQuestions = questionController.filteredQuestion.length;

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
                            widget.category,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: kDarkSecondaryColor,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              formatTime(widget.seconds),
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
                          Obx(
                            () => Text(
                              "${questionController.questionNumber.value}/$totalQuestions",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: kDarkSecondaryColor,
                              ),
                            ),
                          ),

                          Obx(() {
                            double progress =
                                totalQuestions > 0
                                    ? questionController.questionNumber.value /
                                        totalQuestions
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
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
              // กล่อง: คุณตอบไม่ถูกต้อง
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 350, // Set the desired height here
                    child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: questionController.updateTheQnNum,
                      itemCount: questionController.filteredQuestion.length,
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        return CheckfaultCard(
                          question: questionController.filteredQuestion[index],
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 32),
                      onPressed: () {
                        if (_pageController.page! > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                    // เปลี่ยนปุ่มถัดไปเป็น Next Lesson เมื่อคำถามหมด
                    IconButton(
                      icon: const Icon(Icons.arrow_forward, size: 32),
                      onPressed: () {
                        if (_pageController.page! <
                            questionController.filteredQuestion.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          // เปลี่ยนข้อความเป็น Next Lesson เมื่อคำถามหมด
                          showNextLessonDialog(
                            context,
                          ); // ฟังก์ชั่นแสดง dialog หรือการเปลี่ยนหน้าต่อไป
                        }
                      },
                    ),
                  ],
                ),
              ),

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
