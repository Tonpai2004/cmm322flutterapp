import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:flutter/services.dart' show rootBundle; //เผื่อไว้สำหรับแก้ตอนเปิด pdf แบบ emulator
import 'package:path_provider/path_provider.dart'; //เผื่อไว้สำหรับแก้ตอนเปิด pdf แบบ emulator
import 'package:open_filex/open_filex.dart'; //เผื่อไว้สำหรับแก้ตอนเปิด pdf แบบ emulator
import 'dart:io'; //เผื่อไว้สำหรับแก้ตอนเปิด pdf แบบ emulator
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'enroll mobile.dart';
import 'enrolled.dart';
import '../../firebase_options.dart';
import '../quiz/quiz_screen.dart';
import 'homepage.dart';
import 'login.dart';
import 'mockup_profile.dart';
import 'support_page.dart';
import 'navbar.dart';
import 'footer.dart';

Future<void> openDocs() async {
  if (kIsWeb) {
    // ถ้าเป็น Web
    final url = Uri.parse('assets/docs/cmm214_exampledoc.pdf');
    if (!await launchUrl(url, webOnlyWindowName: '_blank')) {
      throw 'Could not launch $url';
    }
  } else {
    // ถ้าเป็น Android/iOS/Desktop
    // 1. ดึงไฟล์จาก asset
    final bytes = await rootBundle.load('assets/docs/cmm214_exampledoc.pdf');
    final list = bytes.buffer.asUint8List();

    // 2. สร้างไฟล์ชั่วคราว
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/cmm214_exampledoc.pdf').create();
    await file.writeAsBytes(list);

    // 3. เปิดไฟล์ด้วย open_filex
    await OpenFilex.open(file.path);
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Inter'),
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
  VideoData(title: 'Clip 1: Make An Eye Socket!', url: 'https://www.youtube.com/watch?v=1D0jAfm18rw', chapter: 'Chapter 1'),
  VideoData(title: 'Clip 2: Tentacle and Eyeball', url: 'https://www.youtube.com/watch?v=LMqxMvmwK48', chapter: 'Chapter 1'),
  VideoData(title: 'Clip 1: Make UV', url: 'https://www.youtube.com/watch?v=4slG1ALyjAw', chapter: 'Chapter 2'),
  VideoData(title: 'Clip 1: Texture Substance', url: 'https://www.youtube.com/watch?v=DDFRPFnCPc8', chapter: 'Chapter 3'),
  VideoData(title: 'Clip 1: Light & Render', url: 'https://www.youtube.com/watch?v=IVTZP9dmzxM', chapter: 'Chapter 4'),
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
  bool hasShownPopup = false;
  bool isNavigatedFromButton = false; // ✅ เพิ่มตัวแปร flag
  String profilePath = 'assets/images/grayprofile.png';

  YoutubePlayerController? _youtubeController;
  bool hasValidVideo = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    checkLoginStatus();

    final currentVideoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    debugPrint('Video ID = $currentVideoId'); // ช่วย debug ได้มาก

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

    goToQuizScreenIfNeeded(); // ✅ เพิ่มมาท้ายสุดของ initState
  }

  void goToQuizScreenIfNeeded() {
    if (!isNavigatedFromButton) return; // ✅ ถ้าไม่ได้มาจากปุ่ม Next/Prev ก็ไม่ต้องเด้ง

    if (currentIndex == 1) { // Chapter 1 วิดีโอที่สอง
      Future.delayed(Duration.zero, () {
        Get.to(QuizScreen(category: "CMM214 : 1 Modelling"));
      });
    } else if (currentIndex == 2) { // Chapter 2
      Future.delayed(Duration.zero, () {
        Get.to(QuizScreen(category: "CMM214 : 2 UV Map"));
      });
    } else if (currentIndex == 3) { // Chapter 3
      Future.delayed(Duration.zero, () {
        Get.to(QuizScreen(category: "CMM214 : 3 Texturing"));
      });
    } else if (currentIndex == 4) { // Chapter 4 ✅ ตรงนี้ต้องเป็น 4
      Future.delayed(Duration.zero, () {
        Get.to(QuizScreen(category: "CMM214 : 4 Lighting"));
      });
    }
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

  void navigateToVideo(int newIndex) {
    final isNext = newIndex > currentIndex;
    final currentChapter = widget.chapter;
    final currentChapterVideos = videoList.where((v) => v.chapter == currentChapter).toList();
    final lastVideoOfChapter = currentChapterVideos.last;

    final isAtLastVideoOfChapter = YoutubePlayer.convertUrlToId(lastVideoOfChapter.url) == YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (isAtLastVideoOfChapter && isNext) {
      // ✅ ถ้าอยู่สุดท้ายของ chapter แล้วกด next ไป quiz
      goToQuizScreenForChapter(currentChapter);
    } else if (newIndex >= 0 && newIndex < videoList.length) {
      // ✅ ไปวิดีโอต่อไปตามปกติ
      final video = videoList[newIndex];

      isNavigatedFromButton = true;
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
            const beginLeft = Offset(1.0, 0.0);
            const end = Offset.zero;
            const beginRight = Offset(-1.0, 0.0);
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
  }

  void goToQuizScreenForChapter(String chapter) {
    String category = "";

    switch (chapter) {
      case "Chapter 1":
        category = "CMM214 : 1 Modelling";
        break;
      case "Chapter 2":
        category = "CMM214 : 2 UV Map";
        break;
      case "Chapter 3":
        category = "CMM214 : 3 Texturing";
        break;
      case "Chapter 4":
        category = "CMM214 : 4 Lighting";
        break;
      default:
        category = "Unknown Chapter";
    }

    Get.to(() => QuizScreen(category: category));
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
            'Videos not found',
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
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFCFFFFA),
                                    foregroundColor: const Color(0xFF253366),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: openDocs,
                                  child: const Text('SHEET'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
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
                                  child: const Text('< Previous'),
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
                                  child: const Text('Next >'),
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