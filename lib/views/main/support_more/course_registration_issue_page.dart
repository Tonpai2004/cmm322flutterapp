import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../enroll mobile.dart';
import '../enrolled.dart';
import '../homepage.dart';
import '../login.dart';
import '../navbar.dart';
import '../footer.dart';
import '../profile_page.dart';
import '../support_page.dart';

class CourseRegistrationIssuePage extends StatefulWidget {
  const CourseRegistrationIssuePage({Key? key}) : super(key: key);

  @override
    _CourseRegistrationIssuePageState createState() => _CourseRegistrationIssuePageState();
  }

class _CourseRegistrationIssuePageState extends State<CourseRegistrationIssuePage> {
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

                  // ปุ่มย้อนกลับ
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
                      'Course Registration Issues',
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
                        '• Slow system response during registration\n'
                            '• Loading errors when selecting courses\n'
                            '• System crashes due to high traffic\n'
                            '• Unable to find available courses',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // หัวข้อการแก้ไข
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
                            '• Ensure a stable internet connection',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Refresh the page or restart the application',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Try registering during off-peak hours (e.g., early morning)',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Clear your browser or app cache',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '• If the issue persists, contact support at ',
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
                                  text: ' for assistance',
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
