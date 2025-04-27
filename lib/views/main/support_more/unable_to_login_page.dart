import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../enrolled.dart';
import '../homepage.dart';
import '../login.dart';
import '../mockup_profile.dart';
import '../navbar.dart';
import '../footer.dart';
import '../support_page.dart';

class UnableToLoginPage extends StatefulWidget {
  const UnableToLoginPage({Key? key}) : super(key: key);

  @override
  _UnableToLoginPageState createState() => _UnableToLoginPageState();
}

class _UnableToLoginPageState extends State<UnableToLoginPage> {
  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/grayprofile.png';

  final TextEditingController _issueController = TextEditingController();

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
      backgroundColor: const Color(0xFFF3FFFE),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
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

                  // ปุ่มย้อนกลับเป็นไอคอน
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CD1C2),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          padding: const EdgeInsets.all(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF212D61),
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // หัวข้อ
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Unable to Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212D61),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // กรอบปัญหา สีแดง
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        border: Border.all(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '• Incorrect username or password\n'
                            '• Account has been locked or suspended\n'
                            '• Server maintenance or downtime\n'
                            '• Forgotten login credentials',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // หัวข้อการแก้ไขปัญหา
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Solutions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212D61),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // กรอบการแก้ไข สีเหลือง
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.yellow[50],
                        border: Border.all(color: Colors.amber, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• Double-check your username and password',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Reset your password if forgotten',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // ข้อความแทรกเมล์ไว้ตรงกลาง
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '• Contact support at ',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                                TextSpan(
                                  text: '*Orcomit@kmutt.ac.th*',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                                TextSpan(
                                  text: ' if your account is locked',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Footer
            const Footer(),
          ],
        ),
      ),
    );
  }
}
