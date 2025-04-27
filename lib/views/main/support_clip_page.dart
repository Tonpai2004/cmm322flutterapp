import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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
    home: SupportClipPage(),
  ));
}

class SupportClipPage extends StatefulWidget {
  const SupportClipPage({super.key});

  @override
  State<SupportClipPage> createState() => _SupportClipPageState();
}

class _SupportClipPageState extends State<SupportClipPage> {
  late YoutubePlayerController _ytController;
  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/grayprofile.png';

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
  void initState() {
    super.initState();
    checkLoginStatus();

    const videoId = '4senIJ6TU_o';

    _ytController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        controlsVisibleAtStart: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _ytController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _ytController,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFF2FFFE),
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
                  onMyCourses: () {},
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Home > Support > How to use',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: player,
                        ),
                        const SizedBox(height: 24), // เว้นระยะห่างจากคลิปวิดีโอ
                        SizedBox(
                          width: 150, // ปุ่มขยายเต็มความกว้าง
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF54EDDC), // สีปุ่ม
                              padding: const EdgeInsets.symmetric(vertical: 16), // ความสูงปุ่ม
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24), // ปุ่มมุมโค้ง
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const HomePage()),
                              );
                            },
                            child: const Text(
                              'Done',
                              style: TextStyle(
                                color: Colors.white, // สีตัวหนังสือ
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Footer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
