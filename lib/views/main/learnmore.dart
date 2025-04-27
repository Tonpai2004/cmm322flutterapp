import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'enrolled.dart';
import 'homepage.dart';
import 'login.dart';
import 'mockup_profile.dart';
import 'support_page.dart';
import 'navbar.dart';
import 'footer.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'Inter',
    ),
    home: LearnMorePage(),
  ));
}

class LearnMorePage extends StatefulWidget {
  const LearnMorePage({super.key});

  @override
  State<LearnMorePage> createState() => _LearnMorePageState();
}

class _LearnMorePageState extends State<LearnMorePage> {
  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/grayprofile.png';

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
          profilePath = 'assets/images/default_profile.jpg'; // เปลี่ยนเป็นรูปโปรไฟล์เมื่อ login
        } else {
          isLoggedIn = false;
          profilePath = 'assets/images/grayprofile.png'; // รูปที่ใช้ตอนไม่ได้ล็อกอิน
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    return Scaffold(
      backgroundColor: const Color(0xFFCFFFFA),
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
                  MaterialPageRoute(builder: (context) => const MockProfilePage()),
                );
              },
              onLogout: () async {
                await FirebaseAuth.instance.signOut();
                setState(() {
                  isLoggedIn = false;
                });
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ✅ รูปด้านบน
                    Container(
                      padding: const EdgeInsets.all(100),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Recording_room.jpg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withAlpha(50),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Column(
                        children: const [
                          Text(
                            'CMM',
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(height: 0),
                          Text(
                            'Computer Science-Multimedia',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                      child: const Text(
                        'CMM, or ComputerScience & Multimedia, '
                            'is a specialized academic unit under King Mongkut’s University of Technology Thonburi (KMUTT). '
                            'It was established to support interdisciplinary learning and research that address real-world challenges '
                            'through the integration of knowledge from various fields. CMM emphasizes innovation, critical thinking, '
                            'and collaboration across disciplines, aiming to produce graduates who are adaptable and equipped '
                            'for diverse professional environments. The college offers unique programs that combine science, '
                            'technology, design, and business to foster holistic problem-solving and lifelong learning.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF212D61),
                          height: 1.6,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Wrap(
                        spacing: 40,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildImageViewer('assets/images/classroom_com.jpg'),
                          _buildImageViewer('assets/images/studio.jpg'),
                          _buildImageViewer('assets/images/library.jpg'),
                          _buildImageViewer('assets/images/library2.jpg'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageViewer(String imagePath) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // คำนวณขนาดตามหน้าจอ เช่น 40% ของหน้าจอ หรือสูงสุดไม่เกิน 200px
        double imageSize = MediaQuery.of(context).size.width * 0.4;
        imageSize = imageSize > 200 ? 200 : imageSize;

        return GestureDetector(
          onTap: () => showImageDialog(imagePath),
          child: Container(
            width: imageSize,
            height: imageSize,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        );
      },
    );
  }


  void showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
