import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contentpagecmmapp/utils/constants.dart';
import 'package:contentpagecmmapp/views//quiz/quiz_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../main/enroll mobile.dart';
import '../main/enrolled.dart';
import '../main/homepage.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง ลิงก์หน้าHome มาจากไฟล์นี้ //
import '../main/login.dart';
import '../main/navbar.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง Navbar มาจากไฟล์นี้ //
import '../main/footer.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง Footer มาจากไฟล์นี้ //
import 'package:contentpagecmmapp/controllers/question_controller.dart';

import '../main/profile_page.dart';
import '../main/support_page.dart';

class QuizCategoryScreen extends StatefulWidget {
  QuizCategoryScreen({super.key});

  @override
  State<QuizCategoryScreen> createState() => _QuizCategoryScreenState();
}

class _QuizCategoryScreenState extends State<QuizCategoryScreen> {

  // เอาไว้เช็คค่าสถานะว่าแท็บ Menu ได้เปิดไปหรือไม่ อย่าลืมเอาไปใส่ด้วย //
  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/default_profile.jpg';

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
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

  final QuestionController _questionController = Get.find<QuestionController>();

  @override
  Widget build(BuildContext context) {

    // 2อันนี้เอาไว้วัดขนาดหน้าจอ อย่าลืมเอาไปใส่ในไฟล์ด้วย จะได้ Responsive menu ของ Navbar ได้ถูกต้อง //
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
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
                  MaterialPageRoute(
                    builder: (context) => const LoginRegisterPage(showLogin: true),
                  ),
                );
              },
              onRegister: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginRegisterPage(showRegister: true),
                  ),
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
                      profilePath = updatedImagePath;  // อัพเดตรูปโปรไฟล์ที่นี่
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

            // ใช้ Expanded หรือ Container เพื่อจัดตำแหน่ง GridView ให้ตรงกลาง
            Expanded(
              child: Center(
                child: Obx(() {
                  // ใช้ isMobile ในการตรวจสอบขนาดหน้าจอ
                  final crossAxisCount = isMobile ? 2 : 4;

                  // ใช้ Obx เพื่อให้แน่ใจว่า UI จะรีเฟรชเมื่อ savedCategories หรือ savedSubtitle เปลี่ยนแปลง
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount, // เปลี่ยนตามขนาดหน้าจอ
                    ),
                    itemCount: _questionController.savedCategories.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(QuizScreen(category: _questionController.savedCategories[index]));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.question_answer),
                              Text(_questionController.savedCategories[index]),
                              Text(_questionController.savedSubtitle[index]),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),

            const Footer(),
          ],
        ),
      ),
    );
  }
}
