import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contentpagecmmapp/views/main/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../views/main/homepage.dart';
import '../../../views/main/login.dart';
import '../../../views/main/support_page.dart';
import '../../../views/main/navbar.dart';
import '../../../views/main/footer.dart';
import '../../firebase_options.dart';
import 'enroll mobile.dart';
import 'enrolled.dart';
import 'maincontent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    GetMaterialApp(  // ใช้ GetMaterialApp แทน MaterialApp
      theme: ThemeData(fontFamily: 'Inter'),
      home: Enroll(),  // หรือหน้าหลักที่คุณต้องการ
    ),
  );
}
class Enroll extends StatefulWidget {
  const Enroll({super.key});

  @override
  State<Enroll> createState() => _EnrollState();
}

class _EnrollState extends State<Enroll> {
  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/default_profile.jpg';

  bool alreadyEnrolled = false;

  final String videoUrl = 'https://www.youtube.com/watch?v=1D0jAfm18rw';

  final List<Map<String, String>> courseSections = [
    {
      'title': 'About This Course',
      'description': 'CMM214 Animation Fundamental is a course about the basics of 3D animation.',
    },
    {
      'title': 'Course Content',
      'description': 'The course is divided into four lessons, each focusing on a different aspect of animation techniques, such as Modeling, UV unwrapping, Texturing, Lighting, and Rendering.',
    },
    {
      'title': 'Application Details',
      'description': "1.Create an account in CMMAPP\n2.Click on 'Register this course' to continue\n3.After that, get ready to learn what you want!",
    },
  ];

  Future<void> checkIfEnrolled() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? studentId = prefs.getString('studentId');

      if (studentId != null) {
        final firestore = FirebaseFirestore.instance;
        final snapshot = await firestore
            .collection('enrollments')
            .where('studentId', isEqualTo: studentId)
            .where('courseId', isEqualTo: 'FLTR101')
            .get();

        setState(() {
          alreadyEnrolled = snapshot.docs.isNotEmpty;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    fetchAndSaveStudentId().then((_) => checkIfEnrolled());
  }

  Future<void> fetchAndSaveStudentId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;

      final querySnapshot = await firestore
          .collection('students')
          .where('email', isEqualTo: user.email) // หรือหาโดย email ก็ได้ ถ้ามี field email ใน students
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
      backgroundColor: const Color(0xFFCFFFFA),
      body: SafeArea(
        child: SingleChildScrollView(
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

              // ---------------------------
              // ข้อมูลหลักสูตร
              // ---------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: AutoSizeText(
                        'CMM214 Animation Fundamental',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                        maxFontSize: 60,
                        minFontSize: 30,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      child: AutoSizeText(
                        'Subject Category: Animation',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Inter',
                        ),
                        maxFontSize: 40,
                        minFontSize: 18,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      child: AutoSizeText(
                        'Course Code: 212224236248',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Inter',
                        ),
                        maxFontSize: 40,
                        minFontSize: 18,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      child: AutoSizeText(
                        'Number of Lessons: 4 lessons',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Inter',
                        ),
                        maxFontSize: 40,
                        minFontSize: 18,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      child: AutoSizeText(
                        'Participants Enrolled: 92 people',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Inter',
                        ),
                        maxFontSize: 40,
                        minFontSize: 18,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      child: AutoSizeText(
                        'Highest Score in This Course: 20 points',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Inter',
                        ),
                        maxFontSize: 40,
                        minFontSize: 18,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      child: AutoSizeText(
                        'Course End Date: 05/04/2025',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Inter',
                        ),
                        maxFontSize: 40,
                        minFontSize: 18,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 0),
                    const Divider(color: Color(0xFF6BFFEE), thickness: 4),
                    const SizedBox(height: 10),
                    Container(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (isLoggedIn) {
                            if (alreadyEnrolled) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const MainContentPage(lessonId: 'FLTR101')));
                            } else {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              String? studentId = prefs.getString('studentId');

                              if (studentId != null) {
                                final firestore = FirebaseFirestore.instance;

                                await firestore.collection('enrollments').add({
                                  'studentId': studentId,
                                  'courseId': 'FLTR101',
                                  'enrolledAt': Timestamp.now(),
                                });

                                setState(() {
                                  alreadyEnrolled = true;
                                });

                                Navigator.push(context, MaterialPageRoute(builder: (context) => const EnrolledPage()));
                              }
                            }
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginRegisterPage(showLogin: true)),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CD1C2),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: SizedBox(
                          child: AutoSizeText(
                            alreadyEnrolled ? 'Go to course' : 'Register the course',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                            maxFontSize: 40,
                            minFontSize: 20,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ---------------------------
              // อาจารย์ผู้สอน
              // ---------------------------
              buildInfoCard('Instructor', 'PChanin.png'),
              const SizedBox(height: 24),

              // ---------------------------
              // วิดีโอแนะนำคอร์สเรียน
              // ---------------------------
              SizedBox(
                child: AutoSizeText(
                  'Introduction Video for the Course',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2865A5),
                    fontFamily: 'Inter',
                  ),
                  maxFontSize: 40,
                  minFontSize: 20,
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 350,
                color: const Color(0xFF3FA099),
                child: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
                    flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
                  ),
                  showVideoProgressIndicator: true,
                ),
              ),
              const SizedBox(height: 24),

              // ---------------------------
              // รายละเอียดคอร์ส
              // ---------------------------
              Column(
                children: courseSections.map((section) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: buildSimpleCard(section['title']!, section['description']!),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),
              const Footer(), // เพิ่ม Footer ถ้ามี
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, String image1) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFF4BC0B2),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              child: SizedBox(
                child: AutoSizeText(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                  maxFontSize: 40,
                  minFontSize: 20,
                  maxLines: 2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/Jirut.jpg',
                      fit: BoxFit.cover,
                      width: 140,   // ปรับขนาดตามต้องการ
                      height: 140,  // ความกว้าง-สูงเท่ากัน เพื่อให้เป็นวงกลม
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: AutoSizeText(
                      'Mr. Jirut Patanachan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                      ),
                      maxFontSize: 35,
                      minFontSize: 20,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSimpleCard(String title, String description) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // ทำให้มุมตรง ไม่โค้ง
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFF3FA099),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              child: AutoSizeText(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
                maxFontSize: 40,
                minFontSize: 20,
                maxLines: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: AutoSizeText(
                description,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color(0xFF3FA099),
                  fontFamily: 'Inter',
                ),
                maxFontSize: 30,
                minFontSize: 15,
                maxLines: 2,
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
