import 'package:flutter/material.dart';
import 'maincontent_video.dart'; // ✅ เพิ่มไว้แล้ว

void main() {
  runApp(const MyApp());
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
  final int totalVideos = 5;
  final Set<int> watchedVideos = {};

  void updateProgress(int videoIndex) {
    setState(() {
      watchedVideos.add(videoIndex);
    });
  }

  double get progress => watchedVideos.length / totalVideos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FFFE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // แถบบนสุด
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: const Color(0xFF54EDDC),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/cmmlogo.png',
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
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
                                  child: const Text('เรียนต่อ'),
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
                            LinearProgressIndicator(
                              value: progress,
                              minHeight: 12,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                            const SizedBox(height: 10),
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
                                  'title': 'คลิปที่ 1: Make An Eye Socket!',
                                  'duration': '27:22 นาที',
                                  'url': 'https://www.youtube.com/watch?v=1D0jAfm18rw',
                                },
                                {
                                  'title': 'คลิปที่ 2: Tentacle and Eyeball',
                                  'duration': '33:10 นาที',
                                  'url': 'https://www.youtube.com/watch?v=LMqxMvmwK48'
                                },
                                {
                                  'title': 'แบบทดสอบท้ายบท',
                                  'duration': '10 ข้อ'
                                },
                              ];
                            } else if (index == 1) {
                              videoList = [
                                {
                                  'title': 'คลิปที่ 1: Make UV',
                                  'duration': '16:27 นาที',
                                  'url': 'https://www.youtube.com/watch?v=4slG1ALyjAw'
                                },
                                {
                                  'title': 'แบบทดสอบท้ายบท',
                                  'duration': '10 ข้อ'
                                },
                              ];
                            } else if (index == 2) {
                              videoList = [
                                {
                                  'title': 'คลิปที่ 1: Texture Substance',
                                  'duration': '13:20 นาที',
                                  'url': 'https://www.youtube.com/watch?v=DDFRPFnCPc8'
                                },
                                {
                                  'title': 'แบบทดสอบท้ายบท',
                                  'duration': '10 ข้อ'
                                },
                              ];
                            } else if (index == 3) {
                              videoList = [
                                {
                                  'title': 'คลิปที่ 1: Light & Render',
                                  'duration': '16:10 นาที',
                                  'url': 'https://www.youtube.com/watch?v=IVTZP9dmzxM'
                                },
                                {
                                  'title': 'แบบทดสอบท้ายบท',
                                  'duration': '10 ข้อ'
                                },
                              ];
                            } else {
                              videoList = []; // เผื่อไว้ในกรณีที่เพิ่มเกิน 4 บท
                            }

                            return ExpandableLessonTile(
                              lessonTitle: 'บทที่ ${index + 1}',
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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              decoration: const BoxDecoration(
                color: Color(0xFF54EDDC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Center(
                child: Text(
                  'Footer content will be added here soon นะจ๊ะเพื่อนๆ.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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
                    if (video['title'] != 'แบบทดสอบท้ายบท') {
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