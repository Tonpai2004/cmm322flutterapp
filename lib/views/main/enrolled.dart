import 'package:contentpagecmmapp/views/main/maincontent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../views/main/homepage.dart';
import '../../../views/main/login.dart';
import '../../../views/main/mockup_profile.dart';
import '../../../views/main/support_page.dart';
import '../../../views/main/navbar.dart';
import '../../../views/main/footer.dart';
import '../../firebase_options.dart';
import 'enroll mobile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    GetMaterialApp(  // ใช้ GetMaterialApp แทน MaterialApp
      theme: ThemeData(fontFamily: 'Inter'),
      home: EnrolledPage(),  // หรือหน้าหลักที่คุณต้องการ
    ),
  );
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

  List<Map<String, dynamic>> enrolledCourses = []; // เปลี่ยนเป็น list of map

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    loadEnrolledCourses();
  }

  Future<void> fetchAndSaveStudentId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;

      final querySnapshot = await firestore
          .collection('students')
          .where('email', isEqualTo: user.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final studentDoc = querySnapshot.docs.first;
        final studentId = studentDoc['studentId'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('studentId', studentId);
      }
    }
  }

  void checkLoginStatus() async {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      setState(() {
        if (user != null) {
          isLoggedIn = true;
          profilePath = 'assets/images/default_profile.jpg';
          fetchAndSaveStudentId().then((_) {
            loadEnrolledCourses();
          });
        } else {
          isLoggedIn = false;
          profilePath = 'assets/images/grayprofile.png';
        }
      });
    });
  }

  void enrollCourse(String courseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? studentId = prefs.getString('studentId');

    if (studentId != null) {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('enrollments').add({
        'studentId': studentId,
        'courseId': courseId,
        'enrolledAt': Timestamp.now(), // บันทึกวันที่
      });

      loadEnrolledCourses();
    } else {
      print('Student ID not found.');
    }
  }

  void loadEnrolledCourses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? studentId = prefs.getString('studentId');

    if (studentId != null) {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('enrollments')
          .where('studentId', isEqualTo: studentId)
          .get();

      List<Map<String, dynamic>> courses = querySnapshot.docs.map((doc) {
        return {
          'courseId': doc['courseId'],
          'enrolledAt': (doc['enrolledAt'] as Timestamp).toDate(), // แปลงเป็น DateTime
        };
      }).toList();

      setState(() {
        enrolledCourses = courses;
      });
    } else {
      setState(() {
        enrolledCourses = [];
      });
    }
  }

  void cancelEnrollment(String courseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? studentId = prefs.getString('studentId');

    if (studentId != null) {
      final firestore = FirebaseFirestore.instance;

      final querySnapshot = await firestore
          .collection('enrollments')
          .where('studentId', isEqualTo: studentId)
          .where('courseId', isEqualTo: courseId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();

        loadEnrolledCourses();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully canceled enrollment for $courseId')),
        );
      } else {
        print('No enrollment found for this course.');
      }
    } else {
      print('Student ID not found.');
    }
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
                          _InProgressList(courses: enrolledCourses, cancelEnrollment: cancelEnrollment),
                          const _CompletedList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _InProgressList extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  final Function(String) cancelEnrollment;

  const _InProgressList({super.key, required this.courses, required this.cancelEnrollment});

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
        children: courses.map((course) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            child: _CourseCard(
              courseId: course['courseId'],
              enrolledAt: course['enrolledAt'],
              onCancelEnrollment: cancelEnrollment,
            ),
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
        style: TextStyle(fontSize: 24, color: Colors.grey[700], fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final String courseId;
  final DateTime enrolledAt;
  final Function(String) onCancelEnrollment;

  const _CourseCard({
    super.key,
    required this.courseId,
    required this.enrolledAt,
    required this.onCancelEnrollment,
  });

  @override
  Widget build(BuildContext context) {
    String courseName = 'Unknown Course';
    if (courseId == 'CMM214') {
      courseName = 'CMM214 Animation Fundamental';
    }

    String formattedDate = "${enrolledAt.day.toString().padLeft(2, '0')}/${enrolledAt.month.toString().padLeft(2, '0')}/${enrolledAt.year}";

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
            child: Image.asset(
              'assets/images/animation_subject.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,),
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
                Text(
                  'Started learning on: $formattedDate',
                  style: const TextStyle(color: Color(0xFF2865a4)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MainContentPage(lessonId: 'FLTR101')));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF349c94),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Go to Course',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          onCancelEnrollment(courseId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF349c94),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Cancel Enrollment',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}