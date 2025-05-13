import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contentpagecmmapp/views/main/enroll%20mobile.dart';
import 'package:contentpagecmmapp/views/main/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'enroll.dart';
import 'enrolled.dart';
import '../../firebase_options.dart';
import 'learnmore.dart';
import 'login.dart';
import '../main/coming_soon.dart';
import 'support_page.dart';
import 'navbar.dart';
import 'footer.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    GetMaterialApp(  // ใช้ GetMaterialApp แทน MaterialApp
      theme: ThemeData(fontFamily: 'Inter'),
      home: HomePage(),  // หรือหน้าหลักที่คุณต้องการ
    ),
  );
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _RenewMainPageState();
}

class _RenewMainPageState extends State<HomePage> {

  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/default_profile.jpg';

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
    final List<String> categories = [
      'IOT & Dev',
      'Animation',
      'Production',
      'Graphics',
      'Business',
    ];

    final List<Map<String, String>> events = [
      {
        'image' : 'assets/images/studio.jpg',
        'title': 'CMM214 Animation Fundamental',
        'by' : 'P.Jirut',
        'start': 'April 1, 2025',
        'end': 'April 5, 2025'
      },
      {
        'image' : 'assets/images/cloud_computing.jpg',
        'title': 'CMM443 Cloud Computing',
        'by' : 'P.Suriyong',
        'start': 'May 10, 2025',
        'end': 'August 10, 2025'
      },
      {
        'image' : 'assets/images/digital_learning.jpg',
        'title': 'CMM311 Digital Learning Media',
        'by' : 'P.Chanin',
        'start': 'July 15, 2025',
        'end': 'August 15, 2025'
      },
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    return Scaffold(
      backgroundColor: const Color(0xFFCFFFFA),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(100),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/Recording_room.jpg'),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withAlpha(50),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                          child: Column(
                            children:  [
                              Text(
                                'CMM',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              SizedBox(height: 0),
                              Text(
                                'Access learning resources anytime, anywhere.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.05,
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: 200,
                                color: const Color(0xFFF7F7F7),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withAlpha(30),
                                    BlendMode.darken,
                                  ),
                                  child: Image.asset(
                                    'assets/images/library2.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                color: const Color(0xFFF7F7F7),
                                height: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text(
                                      'What is "CMM" ?',
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.045,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'CMM, or ComputerScience & Multimedia....',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03, fontFamily: 'Inter'),
                                      textAlign: TextAlign.justify,
                                    ),

                                    const Spacer(), // 👈 ดัน InkWell ลงล่างสุด

                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const LearnMorePage()),
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(4),
                                        child:  Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                          child: Text(
                                            'Learn more...',
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          width: double.infinity,
                          color: const Color(0xFFCFFFFA),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Subject Category',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.055, fontFamily: 'Inter'),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const EnrollMobile(preselectSubject: true)), // ใส่หน้าที่ต้องการไป
                                        );
                                      },
                                      child: Text(
                                        'ALL',
                                        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.055, fontFamily: 'Inter', color: Colors.black), // ใส่สีให้ดูเหมือนกดได้
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    int itemsPerRow = (constraints.maxWidth / 100).floor();
                                    itemsPerRow = itemsPerRow > 3 ? 3 : itemsPerRow;
                                    double itemWidth = (constraints.maxWidth - (itemsPerRow - 1) * 20) / itemsPerRow;
                                    return Wrap(
                                      spacing: 20,
                                      runSpacing: 40,
                                      alignment: WrapAlignment.center,
                                      children: List.generate(categories.length, (index) {
                                        return SizedBox(
                                          width: itemWidth,
                                          child: _categoryItem(context, categories[index]),
                                        );
                                      }),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        _horizontalSection('Upcoming Events', events),
                        SizedBox(height: 40),
                        const Footer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryItem(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnrollMobile(preferSubject: title),
          ),
        );
      },
      child: SizedBox(
        width: 90,
        child: Column(
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundColor: Color(0xFF54EDDC),
              child: Icon(Icons.book, color: Colors.white, size: 34),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _horizontalSection(String title, List<Map<String, String>> events) {
    final ScrollController scrollController = ScrollController();

    return Container(
      padding: const EdgeInsets.only(top: 20),
      color: const Color(0xFFCFFFFA),
      width: double.infinity,
      height: 420,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style:  TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.055, fontFamily: 'Inter'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EnrollMobile(preselectStatus: true)), // ใส่หน้าที่ต้องการไป
                    );
                  },
                  child: Text(
                    'ALL',
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.055, fontFamily: 'Inter', color: Colors.black), // ใส่สีให้ดูเหมือนกดได้
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return InkWell(
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const Enroll()));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ComingSoon()));
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 220,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF54EDDC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 200,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF7F7F7),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                              ),
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                child: Image.asset(
                                  "${event['image']}",
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event['title'] ?? '',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.05,),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text('By ${event['by']}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.035,),),
                                  const SizedBox(height: 2),
                                  Text('Course Start: ${event['start']}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.035,),),
                                  const SizedBox(height: 2),
                                  Text('Course End: ${event['end']}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width * 0.035,),),
                                  const SizedBox(height: 5),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  left: 15,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
                        padding: const EdgeInsets.only(left: 7),
                        onPressed: () {
                          scrollController.animateTo(
                            scrollController.offset - 200,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 15,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.black),
                        onPressed: () {
                          scrollController.animateTo(
                            scrollController.offset + 200,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
