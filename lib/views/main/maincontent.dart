import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'maincontent_video.dart';
import 'package:flutter/services.dart' show rootBundle; //เผื่อไว้สำหรับแก้ตอนเปิด pdf แบบ emulator
import 'package:path_provider/path_provider.dart'; //เผื่อไว้สำหรับแก้ตอนเปิด pdf แบบ emulator
import 'package:open_filex/open_filex.dart'; //เผื่อไว้สำหรับแก้ตอนเปิด pdf แบบ emulator
import 'dart:io'; //เผื่อไว้สำหรับแก้ตอนเปิด pdf แบบ emulator
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'progress_provider.dart';  // นำเข้า ProgressProvider


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

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'Inter',
    ),
    home: const MainContentPage(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainContentPage(),
    );
  }
}

class MainContentPage extends StatefulWidget {

  const MainContentPage({Key? key}) : super(key: key);

  @override
  _MainContentPageState createState() => _MainContentPageState();
}


class _MainContentPageState extends State<MainContentPage> {

  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/Recording_room.jpg';

  final int totalVideos = 5;
  final Set<int> watchedVideos = {};

  void updateProgress(int videoIndex) {
    setState(() {
      watchedVideos.add(videoIndex);
    });
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
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

  double get progress => watchedVideos.length / totalVideos;

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    return Scaffold(
      backgroundColor: const Color(0xFFF3FFFE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // แถบบนสุด
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

            // หัวข้อ Course
            Container(
              color: const Color(0xFFCFFFFA),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: const Text(
                '3D ANIMATION FUNDAMENTALS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202D61),
                ),
              ),
            ),

            // กรอบหลัก
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
                      // ส่วนหัว
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
                                const Text(
                                  'Subject',
                                  style: TextStyle(
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
                                      value: 0.2,
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
                                  onPressed: openDocs, // เปลี่ยนจาก openPdfWeb() เป็น openDocs
                                  child: const Text('Sheet'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // รายชื่อบทเรียน
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List.generate(4, (index) {
                            // ✅ กำหนดข้อมูล video พร้อมลิงก์
                            List<Map<String, String>> videoList;

                            if (index == 0) {
                              videoList = [
                                {
                                  'title': 'Clip 1: Make An Eye Socket!',
                                  'duration': '27:22 นาที',
                                  'url': 'https://www.youtube.com/watch?v=1D0jAfm18rw',
                                },
                                {
                                  'title': 'Clip 2: Tentacle and Eyeball',
                                  'duration': '33:10 นาที',
                                  'url': 'https://www.youtube.com/watch?v=LMqxMvmwK48'
                                },
                                {
                                  'title': 'Post Test',
                                  'duration': '10 ข้อ'
                                },
                              ];
                            } else if (index == 1) {
                              videoList = [
                                {
                                  'title': 'Clip 1: Make UV',
                                  'duration': '16:27 นาที',
                                  'url': 'https://www.youtube.com/watch?v=4slG1ALyjAw'
                                },
                                {
                                  'title': 'Post Test',
                                  'duration': '10 ข้อ'
                                },
                              ];
                            } else if (index == 2) {
                              videoList = [
                                {
                                  'title': 'Clip 1: Texture Substance',
                                  'duration': '13:20 นาที',
                                  'url': 'https://www.youtube.com/watch?v=DDFRPFnCPc8'
                                },
                                {
                                  'title': 'Post Test',
                                  'duration': '10 ข้อ'
                                },
                              ];
                            } else if (index == 3) {
                              videoList = [
                                {
                                  'title': 'Clip 1: Light & Render',
                                  'duration': '16:10 นาที',
                                  'url': 'https://www.youtube.com/watch?v=IVTZP9dmzxM'
                                },
                                {
                                  'title': 'Post Test',
                                  'duration': '10 ข้อ'
                                },
                              ];
                            } else {
                              videoList = []; // เผื่อไว้ในกรณีที่เพิ่มเกิน 4 บท
                            }

                            return ExpandableLessonTile(
                              lessonTitle: 'Chapter ${index + 1}',
                              videos: videoList,
                              chapterNumber: index + 1,
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
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

class ExpandableLessonTile extends StatefulWidget {
  final String lessonTitle;
  final int chapterNumber;
  final List<Map<String, String>> videos;

  const ExpandableLessonTile({
    super.key,
    required this.lessonTitle,
    required this.videos,
    required this.chapterNumber,
  });

  @override
  State<ExpandableLessonTile> createState() => _ExpandableLessonTileState();
}

class _ExpandableLessonTileState extends State<ExpandableLessonTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.lessonTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202D61),
                ),
              ),
            ),
          ),
        ),
        if (isExpanded)
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(1.0),
              ),
            ),

            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Column(
              children: widget.videos.map((video) {
                return InkWell(
                  onTap: () {
                    if (video['title'] != 'Post Test') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MainContentVideoPage(
                            videoTitle: video['title']!,
                            videoUrl: video['url'] ?? '', // ป้องกัน null
                            chapter: widget.lessonTitle,
                          ),
                        ),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(video['title']!, style: const TextStyle(fontSize: 15)),
                          Text(video['duration']!, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      const Divider(height: 20, thickness: 1, color: Color(0xFFE0E0E0)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}