import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class MainContentVideoPage extends StatefulWidget {
  const MainContentVideoPage({super.key, required String videoTitle});

  @override
  State<MainContentVideoPage> createState() => _MainContentVideoPageState();
}

class _MainContentVideoPageState extends State<MainContentVideoPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    )..initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        allowPlaybackSpeedChanging: true, // สำหรับเปลี่ยนความเร็ว
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.teal,
          handleColor: Colors.tealAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightGreen,
        ),
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FFFE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Top Bar
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
                  Image.asset(
                    'assets/images/cmmlogo.png',
                    height: 40,
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // ✅ Course Header
            Container(
              color: const Color(0xFFCFFFFA),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: const Text(
                'Course',
                style: TextStyle(
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
                        child: _chewieController != null &&
                            _chewieController!.videoPlayerController.value.isInitialized
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                'บทที่ x: ผึ้งน้อยผสมพันธุ์',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF202D61),
                                ),
                              ),
                            ),
                            AspectRatio(
                              aspectRatio:
                              _videoPlayerController.value.aspectRatio,
                              child: Chewie(
                                controller: _chewieController!,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // ✅ ปุ่ม ก่อนหน้า / ถัดไป แบบขอบมน ไม่มีกรอบ
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // ฟังก์ชันยังไม่ใส่
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color(0xFFFFFFFF),
                                    foregroundColor: Color(0xFF202D61),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text('< ก่อนหน้า'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // ฟังก์ชันยังไม่ใส่
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color(0xFFFFFFFF),
                                    foregroundColor: Color(0xFF202D61),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text('ถัดไป >'),
                                ),
                              ],
                            ),
                          ],
                        )
                            : const Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ✅ Footer
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
