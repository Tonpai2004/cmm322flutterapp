import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contentpagecmmapp/views/main/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'enroll mobile.dart';
import 'enrolled.dart';
import 'homepage.dart';
import 'login.dart';
import 'navbar.dart';
import 'footer.dart';
import '../main/support_more/unable_to_login_page.dart';
import '../main/support_more/unable_login_to_student_or_staff_account.dart';
import '../main/support_more/unable_to_locate_course_page.dart';
import '../main/support_more/course_registration_issue_page.dart';
import 'support_clip_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Inter',
    ),
    home: SupportPage(),
  ));
}

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
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

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 14.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFCFFFFA),
                    ),
                    child: const Text(
                      'Support',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212D61),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildExpansionTileBox(
                    context: context,
                    title: 'For the general public',
                    backgroundColor: const Color(0xFF4CD1C2),
                    titleTextColor: const Color(0xFF212D61),
                    contentTiles: [
                      _buildClickableTile(
                        title: 'Unable to login',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UnableToLoginPage()),
                          );
                        },
                      ),
                      _buildClickableTile(
                        title: 'User Access Guide',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SupportClipPage()),
                          );
                        },
                      ),
                      _buildClickableTile(
                        title: 'Unable to locate the course in the system',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UnableToLocateCoursePage()),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _buildExpansionTileBox(
                    context: context,
                    title: 'For students and staff',
                    backgroundColor: const Color(0xFF4CD1C2),
                    titleTextColor: const Color(0xFF212D61),
                    contentTiles: [
                      _buildClickableTile(
                        title: 'Unable to login to your student or staff account',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const UnableLoginToStudentOrStaffAccount()),
                          );
                        },
                      ),
                      _buildClickableTile(
                        title: 'The course registration system is experiencing issues.',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CourseRegistrationIssuePage()),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Report additional issues',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212D61),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Specify details...',
                                  filled: true,
                                  fillColor: Color(0xFFCFFFFA),
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Color(0xFF2865A5),
                                  ),
                                ),
                                style: TextStyle(
                                  color: Color(0xFF2865A5),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4CD1C2),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Sent successfully.')),
                                );
                              },
                              child: const Icon(
                                Icons.send,
                                color: Color(0xFF212D61),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTileBox({
    required BuildContext context,
    required String title,
    required Color backgroundColor,
    required List<Widget> contentTiles,
    Color titleTextColor = Colors.white,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.zero,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ExpansionTile(
          collapsedIconColor: titleTextColor,
          iconColor: titleTextColor,
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: titleTextColor,
              fontSize: 16,
            ),
          ),
          children: contentTiles,
        ),
      ),
    );
  }

  Widget _buildColoredTile(String text) {
    return Container(
      color: const Color(0xFFCFFFFA),
      child: ListTile(
        title: Text(
          text,
          style: const TextStyle(color: Color(0xFF212D61)),
        ),
      ),
    );
  }

  Widget _buildClickableTile({
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      color: const Color(0xFFCFFFFA),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Color(0xFF212D61)),
        ),
        onTap: onTap,
      ),
    );
  }
}
