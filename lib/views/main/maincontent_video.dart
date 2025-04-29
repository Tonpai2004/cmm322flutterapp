import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contentpagecmmapp/views/main/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'enroll mobile.dart';
import 'enrolled.dart';
import '../../firebase_options.dart';
import '../quiz/quiz_screen.dart';
import 'homepage.dart';
import 'login.dart';
import 'support_page.dart';
import 'navbar.dart';
import 'footer.dart';

Future<void> openDocs() async {
  if (kIsWeb) {
    final url = Uri.parse('assets/docs/cmm214_exampledoc.pdf');
    if (!await launchUrl(url, webOnlyWindowName: '_blank')) {
      throw 'Could not launch $url';
    }
  } else {
    final bytes = await rootBundle.load('assets/docs/cmm214_exampledoc.pdf');
    final list = bytes.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/cmm214_exampledoc.pdf').create();
    await file.writeAsBytes(list);
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
  String profilePath = 'assets/images/grayprofile.png';

  YoutubePlayerController? _youtubeController;
  bool hasValidVideo = false;
  int currentIndex = 0;

  double progress = 0.6;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();

    final currentVideoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    debugPrint('Video ID = $currentVideoId');

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

  void navigateToVideo(int newIndex) {
    final video = videoList[newIndex];
    final isNext = newIndex > currentIndex;

    if (newIndex >= 0 && newIndex < videoList.length) {
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
            final tween = Tween<Offset>(begin: isNext ? beginLeft : beginRight, end: end).chain(CurveTween(curve: Curves.easeInOut));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }
  }

  void showTestPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Post test'),
          content: const Text('Do you want to do this?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();

                if (currentIndex == 2) {
                  Get.to(QuizScreen(category: "CMM214 : 1 Modelling"));
                } else if (currentIndex == 3) {
                  Get.to(QuizScreen(category: "CMM214 : 2 UV Map"));
                } else if (currentIndex == 4) {
                  Get.to(QuizScreen(category: "CMM214 : 3 Texturing"));
                } else if (currentIndex == 5) {
                  Get.to(QuizScreen(category: "CMM214 : 4 Lighting"));
                }
              },
            ),
          ],
        );
      },
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
            'Videos not found',
            style: TextStyle(color: Colors.red[900], fontSize: 18),
          ),
        ),
      );
    }

    if (currentIndex == 2 || currentIndex == 3 || currentIndex == 4 || currentIndex == 5) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showTestPopup();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3FFFE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              'Progress in Studying',
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
                                      value: progress,
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
                                  onPressed: openDocs,
                                  child: const Text('Sheet'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                                      ? () {
                                    setState(() {
                                      currentIndex--;
                                      progress = currentIndex / videoList.length;
                                    });
                                    navigateToVideo(currentIndex);
                                  }
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
                                      ? () {
                                    setState(() {
                                      currentIndex++;
                                      progress = currentIndex / videoList.length;
                                    });
                                    navigateToVideo(currentIndex);
                                  }
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
            const Footer(),
          ],
        ),
      ),
    );
  }
}
