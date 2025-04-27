import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../views/main/homepage.dart';
import '../views/main/login.dart';
import '../views/main/mockup_profile.dart';
import '../views/main/support_page.dart';
import '../views/main/navbar.dart';
import '../views/main/footer.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Inter',
    ),
    home: EnrolledPage(),
  ));
}

class EnrolledPage extends StatefulWidget {
  const EnrolledPage({super.key});

  @override
  State<EnrolledPage> createState() => _EnrolledPageState();
}

class _EnrolledPageState extends State<EnrolledPage> {

  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/Recording_room.jpg';

  List<String> enrolledCourses = [];

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    loadEnrolledCourses();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('isLoggedIn');
    String? storedProfilePath = prefs.getString('profileImagePath');

    setState(() {
      isLoggedIn = loggedIn ?? false;
      if (storedProfilePath != null && storedProfilePath.isNotEmpty) {
        profilePath = storedProfilePath;
      }
    });
  }

  void loadEnrolledCourses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? courses = prefs.getStringList('enrolledCourses');
    setState(() {
      enrolledCourses = courses ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    return DefaultTabController(
      length: 2,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFB2F1E6),
            body: Column(
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
                    setState(() => _isMenuOpen = false);
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
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.remove('isLoggedIn');
                    await prefs.remove('enrolledCourses'); // <--- เพิ่มบรรทัดนี้
                    setState(() {
                      isLoggedIn = false;
                      enrolledCourses = []; // <--- เคลียร์ list ทันทีใน memory ด้วย
                    });
                  },
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'My Courses',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212d61),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white38,
                          ),
                          child: const TabBar(
                            labelColor: Color(0xFF212d61),
                            labelStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            unselectedLabelColor: Color(0xFF2865a4),
                            unselectedLabelStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            indicator: BoxDecoration(
                              color: Color(0xFF4cd1c2),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabs: [
                              Tab(text: 'In progress'),
                              Tab(text: 'Completed studying.'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _InProgressList(courses: enrolledCourses),
                              const _CompletedList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class _InProgressList extends StatelessWidget {
  final List<String> courses;

  const _InProgressList({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return Center(
        child: Text(
          'No courses found.',
          style: TextStyle(fontSize: 24, color: Colors.grey[700], fontWeight: FontWeight.bold),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: courses.map((courseId) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: _CourseCard(courseId: courseId),
          );
        }).toList(),
      ),
    );
  }
}



class _CompletedList extends StatelessWidget {
  const _CompletedList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No completed courses yet.',
        style: TextStyle(fontSize: 24, color: Colors.grey[700],fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final String courseId;

  const _CourseCard({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    // เอาไว้ดักหลายคอร์สในอนาคต
    String courseName = 'Unknown Course';
    if (courseId == 'CMM214') {
      courseName = 'CMM214 Animation Fundamental';
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF4cd1c2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFffffff),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Photo',
              style: TextStyle(fontSize: 24, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 26),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212d61),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Learning progress: 0%',
                  style: TextStyle(color: Color(0xFF2865a4)),
                ),
                const Text(
                  'Started learning on: 01/04/2025',
                  style: TextStyle(color: Color(0xFF2865a4)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF349c94),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'About the course',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF349c94),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Cancel registration',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}