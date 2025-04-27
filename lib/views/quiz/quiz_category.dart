import 'package:contentpagecmmapp/utils/constants.dart';
import 'package:contentpagecmmapp/views//quiz/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../main/homepage.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง ลิงก์หน้าHome มาจากไฟล์นี้ //
import '../main/navbar.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง Navbar มาจากไฟล์นี้ //
import '../main/footer.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง Footer มาจากไฟล์นี้ //
import 'package:contentpagecmmapp/controllers/question_controller.dart';

class QuizCategoryScreen extends StatefulWidget {
  QuizCategoryScreen({super.key});

  @override
  State<QuizCategoryScreen> createState() => _QuizCategoryScreenState();
}

class _QuizCategoryScreenState extends State<QuizCategoryScreen> {

  // เอาไว้เช็คค่าสถานะว่าแท็บ Menu ได้เปิดไปหรือไม่ อย่าลืมเอาไปใส่ด้วย //
  bool _isMenuOpen = false;
  bool isLoggedIn = false;

  final QuestionController _questionController = Get.put(QuestionController());

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
              // ก็อปตัวนี้ไปลงในไฟล์ดู ไม่ได้ก็ลองให้ ChatGPT ช่วยปรับแต่งให้มันลงรอยกัน เพราะโครงสร้างโค้ดแต่ละคนมันไม่เหมือนกัน ไม่การันตีว่าจะไม่เกิดเออเร่อ //
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
