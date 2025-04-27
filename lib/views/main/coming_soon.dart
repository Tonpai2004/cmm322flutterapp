import 'package:contentpagecmmapp/views/main/support_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'enrolled.dart';
import '../main/homepage.dart';
import '../main/learnmore.dart';
import '../main/navbar.dart';
import 'login.dart';
import 'mockup_profile.dart';

void main() {
  runApp(const MaterialApp(home: ComingSoon()));
}

class ComingSoon extends StatefulWidget {
  const ComingSoon({super.key});

  @override
  State<ComingSoon> createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
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
        child: Stack(
          children: [
            Column(
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            size: 160,
                            color: Colors.orangeAccent,
                          ),
                          const SizedBox(height: 0),
                          const Text(
                            'Coming Soon.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}
