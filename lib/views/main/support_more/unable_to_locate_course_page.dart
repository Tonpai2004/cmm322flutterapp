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

class UnableToLocateCoursePage extends StatefulWidget {
  const UnableToLocateCoursePage({Key? key}) : super(key: key);

  @override
  _UnableToLocateCoursePageState createState() => _UnableToLocateCoursePageState();
}

class _UnableToLocateCoursePageState extends State<UnableToLocateCoursePage> {
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
                      'Unable to Locate the Course in the System',
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
                        '• Course ID or course name entered incorrectly\n'
                            '• Course has not been added to the system yet\n'
                            '• System synchronization issues\n'
                            '• User does not have permission to access the course',
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
                            '• Double-check the course ID or course name entered',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Contact course instructor or administrator to confirm course availability',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Wait for system updates or synchronization to complete',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Ensure you are enrolled in the course or have necessary permissions',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              height: 1.2,
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
