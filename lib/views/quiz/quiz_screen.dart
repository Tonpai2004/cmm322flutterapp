import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contentpagecmmapp/utils/constants.dart';
import 'package:contentpagecmmapp/views/quiz/body_quiz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:contentpagecmmapp/controllers/question_controller.dart';
import '../main/enroll mobile.dart';
import '../main/enrolled.dart';
import '../main/homepage.dart';
import '../main/login.dart';
import '../main/navbar.dart';
import '../main/footer.dart';
import '../main/profile_page.dart';
import '../main/support_page.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/default_profile.jpg';

  QuestionController questionController = Get.put(QuestionController());

  @override
  void initState() {
    super.initState();
    checkLoginStatus();

    // รอให้ build เสร็จค่อย reset และโหลดคำถาม
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<QuestionController>();

      controller.resetQuiz();
      controller.setFilteredQuestions(widget.category);
      // ✅ ไม่จำเป็นต้อง jumpToPage(0) ตรงนี้ เพราะ resetQuiz สร้าง PageController ใหม่แล้ว
      // หากใช้ jumpToPage ต้องรอให้ pageController ถูกใช้งานก่อนถึงจะ jump ได้
    });
  }



  void checkLoginStatus() async {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        if (user != null) {
          isLoggedIn = true;
          _loadUserProfile(user.uid); // เปลี่ยนเป็นรูปโปรไฟล์เมื่อ login
        } else {
          isLoggedIn = false;
          profilePath = 'assets/images/default_profile.jpg'; // รูปที่ใช้ตอนไม่ได้ล็อกอิน
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        onSearch: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EnrollMobile())),
                        onMyCourses: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EnrolledPage())),
                        onSupport: () {
                          setState(() => _isMenuOpen = false);
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportPage()));
                        },
                        onLogin: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginRegisterPage(showLogin: true))),
                        onRegister: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginRegisterPage(showRegister: true))),
                        isLoggedIn: isLoggedIn,
                        profileImagePath: profilePath,
                        onProfileTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())).then((updatedImagePath) {
                            if (updatedImagePath != null) {
                              setState(() => profilePath = updatedImagePath);
                            }
                          });
                        },
                        onLogout: () async {
                          await FirebaseAuth.instance.signOut();
                          setState(() => isLoggedIn = false);
                        },
                      ),

                      // Quiz Section (if available)
                      GetX<QuestionController>(
                        builder: (controller) {
                          if (controller.filteredQuestion.isEmpty) {
                            return Center(child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text("No questions available for this category."),
                            ));
                          }

                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.65,
                            child: BodyQuiz(category: widget.category),
                          );
                        },
                      ),

                      const Spacer(),
                      // Footer stays at the bottom
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
}
