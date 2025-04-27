import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    theme: ThemeData(fontFamily: 'Inter'),
    home: Enroll(),
  ));
}

class Enroll extends StatefulWidget {
  const Enroll({super.key});

  @override
  State<Enroll> createState() => _EnrollState();
}

class _EnrollState extends State<Enroll> {
  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/grayprofile.png';

  final String videoUrl = 'https://youtu.be/Wawwhw3oZzc?si=bMy5qbzZmg6uMETy';

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              ResponsiveNavbar(
                isMobile: isMobile,
                isMenuOpen: _isMenuOpen,
                toggleMenu: () => setState(() => _isMenuOpen = !_isMenuOpen),
                goToHome: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage())),
                onMyCourses: () {},
                onSupport: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportPage())),
                onLogin: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginRegisterPage(showLogin: true))),
                onRegister: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginRegisterPage(showRegister: true))),
                isLoggedIn: isLoggedIn,
                profileImagePath: profilePath,
                onProfileTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MockProfilePage())),
                onLogout: () async {
                  await FirebaseAuth.instance.signOut();
                  setState(() => isLoggedIn = false);
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
                    const Text('Subject', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Subject Category:'),
                    const Text('Course Code: 212224234248'),
                    const Text('Number of Lessons: -- lessons'),
                    const Text('Participants Enrolled: -- people'),
                    const Text('Highest Score in This Course: -- points'),
                    const Text('Course End Date: April 60, 2567'),
                    const SizedBox(height: 16),
                    const SizedBox(height: 20),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4BC0B2),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Register the course', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFF6BFFEE), thickness: 4),
                  ],
                ),
              ),

              // ---------------------------
              // อาจารย์ผู้สอน
              // ---------------------------
              buildInfoCard('Instructor', 'PChanin.png', 'Ptum.png'),
              const SizedBox(height: 24),

              // ---------------------------
              // วิดีโอแนะนำคอร์สเรียน
              // ---------------------------
              const Text(
                'วิดีโอแนะนำคอร์สเรียน',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2865A5)),
              ),
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 200,
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
              buildSimpleCard('เกี่ยวกับรายวิชา'),
              const SizedBox(height: 16),
              buildSimpleCard('หัวข้อบทเรียนหลัก'),
              const SizedBox(height: 16),
              buildSimpleCard('รายละเอียดการสมัครเรียน'),

              const SizedBox(height: 32),
              const Footer(), // เพิ่ม Footer ถ้ามี
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, String image1, String image2) {
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
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/images/$image1')),
                  CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/images/$image2')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSimpleCard(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 200,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFF3FA099),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('รายละเอียดเพิ่มเติม...', style: TextStyle(color: Color(0xFF3FA099))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
