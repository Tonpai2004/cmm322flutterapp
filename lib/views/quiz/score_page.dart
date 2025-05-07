import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contentpagecmmapp/controllers/question_controller.dart';
import 'package:contentpagecmmapp/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main/enroll mobile.dart';
import '../main/enrolled.dart';
import '../main/homepage.dart';
import '../main/login.dart';
import '../main/maincontent_video.dart';
import '../main/navbar.dart';
import '../main/footer.dart';
import '../main/profile_page.dart';
import '../main/support_page.dart';
import 'checkfault_screen.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  late int _seconds;
  late String _category;

  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String? profilePath = 'assets/images/default_profile.jpg';

  QuestionController questionController = Get.put(QuestionController());

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    final arguments = Get.arguments as Map<String, dynamic>?;
    _seconds = arguments?['time'] ?? 0;
    _category = arguments?['category'] ?? 'Unknown';
  }

  void checkLoginStatus() async {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        if (user != null) {
          isLoggedIn = true;
          _loadUserProfile(user.uid);
        } else {
          isLoggedIn = false;
          profilePath = 'assets/images/default_profile.jpg';
        }
      });
    });
  }

  Future<void> _loadUserProfile(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('students').doc(userId).get();
    if (doc.exists) {
      final data = doc.data();
      setState(() {
        profilePath = data?['profileImagePath'] ?? 'assets/images/grayprofile.png';
      });
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    int totalQuestions = questionController.filteredQuestion.length;

    String categoryN = _category.split(':')[1].trim().split(' ')[0];
    int categoryInt = int.tryParse(categoryN) ?? 0;
    int currentIndex = categoryInt;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Navbar
                      ResponsiveNavbar(
                        isMobile: isMobile,
                        isMenuOpen: _isMenuOpen,
                        toggleMenu: () => setState(() => _isMenuOpen = !_isMenuOpen),
                        goToHome: () {
                          setState(() => _isMenuOpen = false);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                        },
                        onSearch: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const EnrollMobile()));
                        },
                        onMyCourses: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const EnrolledPage()));
                        },
                        onSupport: () {
                          setState(() => _isMenuOpen = false);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportPage()));
                        },
                        onLogin: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginRegisterPage(showLogin: true)),
                          );
                        },
                        onRegister: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginRegisterPage(showRegister: true)),
                          );
                        },
                        isLoggedIn: isLoggedIn,
                        profileImagePath: profilePath,
                        onProfileTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfilePage()),
                          ).then((updatedImagePath) {
                            if (updatedImagePath != null) {
                              setState(() {
                                profilePath = updatedImagePath;
                              });
                            }
                          });
                        },
                        onLogout: () async {
                          await FirebaseAuth.instance.signOut();
                          setState(() {
                            isLoggedIn = false;
                          });
                        },
                      ),

                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
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
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "You scored",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212D61),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${questionController.numOfCorrectAns}/5 points",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212D61),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Time spent : " + formatTime(_seconds),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF212D61),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            FractionallySizedBox(
                              widthFactor: 0.7,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(CheckfaultScreen(
                                      category: _category,
                                      seconds: _seconds,
                                      currentIndex: currentIndex));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kDarkPrimaryColor,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 5,
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
                              widthFactor: 0.7,
                              child: ElevatedButton(
                                onPressed: currentIndex > 0
                                    ? () => navigateToVideo(currentIndex + 1, currentIndex)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kDarkPrimaryColor,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 5,
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

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Text(
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
                              value: categoryInt / 4.0,
                              backgroundColor: Colors.teal.shade100,
                              color: Colors.teal,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "*Keep going!! Don’t give up yet\nYou've made it past $categoryN/4 of the content",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Color(0xFF3FA099), fontSize: 13),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Spacer(),
                      const Footer(),
                    ],
                  ),
                ),
              ),
            );
          },
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
          const beginLeft = Offset(1.0, 0.0);
          const end = Offset.zero;
          const beginRight = Offset(-1.0, 0.0);

          final tween = Tween<Offset>(
              begin: isNext ? beginLeft : beginRight, end: end)
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
