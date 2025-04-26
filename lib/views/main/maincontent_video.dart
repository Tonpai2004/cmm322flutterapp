import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  ));
}

// ✅ โครงสร้างวิดีโอ
class VideoData {
  final String title;
  final String url;
  final String chapter;

  VideoData({
    required this.title,
    required this.url,
    required this.chapter,
  });
}

// ✅ รายชื่อวิดีโอทั้งหมด (แก้ไขตามข้อมูลจริงของคุณ)
final List<VideoData> videoList = [
  VideoData(title: 'บทที่ 1 คลิปที่ 1', url: 'https://www.youtube.com/watch?v=1D0jAfm18rw', chapter: 'บทที่ 1'),
  VideoData(title: 'บทที่ 1 คลิปที่ 2', url: 'https://www.youtube.com/watch?v=LMqxMvmwK48', chapter: 'บทที่ 1'),
  VideoData(title: 'บทที่ 2 คลิปที่ 1', url: 'https://www.youtube.com/watch?v=4slG1ALyjAw', chapter: 'บทที่ 2'),
  VideoData(title: 'บทที่ 3 คลิปที่ 1', url: 'https://www.youtube.com/watch?v=DDFRPFnCPc8', chapter: 'บทที่ 3'),
  VideoData(title: 'บทที่ 4 คลิปที่ 1', url: 'https://www.youtube.com/watch?v=IVTZP9dmzxM', chapter: 'บทที่ 4'),
];

class MainContentVideoPage extends StatefulWidget {
  final String videoTitle;
  final String videoUrl;
  final String chapter;

  const MainContentVideoPage({
    super.key,
    required this.videoTitle,
    required this.videoUrl,
    required this.chapter,
  });

  @override
  State<MainContentVideoPage> createState() => _MainContentVideoPageState();
}

class _MainContentVideoPageState extends State<MainContentVideoPage> {

  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/Recording_room.jpg';

  YoutubePlayerController? _youtubeController;
  bool hasValidVideo = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    checkLoginStatus();

    final currentVideoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    debugPrint('Video ID = $currentVideoId'); // ช่วย debug ได้มาก

    // เทียบจาก videoId แทนเพื่อกันกรณี URL มีพารามิเตอร์แปลกๆ
    currentIndex = videoList.indexWhere((v) =>
    YoutubePlayer.convertUrlToId(v.url) == currentVideoId &&
        v.chapter == widget.chapter);

    if (currentVideoId != null && widget.videoUrl.isNotEmpty) {
      hasValidVideo = true;
      _youtubeController = YoutubePlayerController(
        initialVideoId: currentVideoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
        ),
      );
    }
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

  void navigateToVideo(int newIndex) {
    final video = videoList[newIndex];
    final isNext = newIndex > currentIndex;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return MainContentVideoPage(
            videoTitle: video.title,
            videoUrl: video.url,
            chapter: video.chapter,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const beginLeft = Offset(1.0, 0.0);   // จากขวาไปซ้าย
          const end = Offset.zero;

          const beginRight = Offset(-1.0, 0.0); // จากซ้ายไปขวา
          final tween = Tween<Offset>(
            begin: isNext ? beginLeft : beginRight,
            end: end,
          ).chain(CurveTween(curve: Curves.easeInOut));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    if (!hasValidVideo || _youtubeController == null) {
      return Scaffold(
        backgroundColor: Colors.red[100],
        body: Center(
          child: Text(
            'ไม่พบลิงก์วิดีโอ',
            style: TextStyle(color: Colors.red[900], fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3FFFE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Top Bar
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
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('isLoggedIn');
                setState(() {
                  isLoggedIn = false;
                });
              },
            ),

            // ✅ Course Header
            Container(
              color: const Color(0xFFCFFFFA),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Text(
                'CMM214 : ${widget.chapter}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202D61),
                ),
              ),
            ),

            // ✅ Main Body
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Header Section
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4BD1C2),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.videoTitle,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF202D61),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'ความคืบหน้าในการเรียน',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2866A5),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    height: 14,
                                    child: LinearProgressIndicator(
                                      value: 0.6,
                                      backgroundColor: const Color(0xFFD9D9D9),
                                      color: const Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFCFFFFA),
                                    foregroundColor: const Color(0xFF253366),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text('ดาวน์โหลดเอกสาร'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // ✅ Video Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFFCFFFFA),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            YoutubePlayer(
                              controller: _youtubeController!,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: Colors.teal,
                              progressColors: const ProgressBarColors(
                                playedColor: Colors.teal,
                                handleColor: Colors.tealAccent,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: currentIndex > 0
                                      ? () => navigateToVideo(currentIndex - 1)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFFFFF),
                                    foregroundColor: const Color(0xFF202D61),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text('< ก่อนหน้า'),
                                ),
                                ElevatedButton(
                                  onPressed: currentIndex < videoList.length - 1
                                      ? () => navigateToVideo(currentIndex + 1)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFFFFF),
                                    foregroundColor: const Color(0xFF202D61),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text('ถัดไป >'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ✅ Footer
            const Footer(),
          ],
        ),
      ),
    );
  }
}