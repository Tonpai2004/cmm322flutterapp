import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'learnmore.dart';
import 'login.dart';
import 'mockup_profile.dart';
import '../main/coming_soon.dart';
import 'support_page.dart';
import 'navbar.dart';
import 'footer.dart';


void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      home: HomePage()));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _RenewMainPageState();
}

class _RenewMainPageState extends State<HomePage> {

  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/Recording_room.jpg';

  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // 👈 เรียกเช็คสถานะล็อกอิน
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
        'image' : 'assets/images/animation_subject.jpg',
        'title': 'CMM214 Animation Fundamental',
        'by' : 'P.Jirut',
        'start': '01/04/2025',
        'end': '30/06/2025'
      },
      {
        'image' : 'assets/images/cloud_computing.jpg',
        'title': 'CMM443 Cloud Computing',
        'by' : 'P.Suriyong',
        'start': '10/05/2025',
        'end': '10/08/2025'
      },
      {
        'image' : 'assets/images/digital_learning.jpg',
        'title': 'CMM311 Digital Learning Media',
        'by' : 'P.Chanin',
        'start': '15/07/2025',
        'end': '15/10/2025'
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
                            children: const [
                              Text(
                                'CMM',
                                style: TextStyle(
                                  fontSize: 60,
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
                                  fontSize: 20,
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
                                    const Text(
                                      'What is "CMM" ?',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'CMM, or ComputerScience & Multimedia....',
                                      style: TextStyle(fontSize: 13, fontFamily: 'Inter'),
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
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                          child: Text(
                                            'Learn more...',
                                            style: TextStyle(
                                              fontSize: 15,
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
                                  children: const [
                                    Text(
                                      'Subject Category',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Inter'),
                                    ),
                                    Text(
                                      'ALL',
                                      style: TextStyle(fontSize: 16, fontFamily: 'Inter'),
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
                                          child: _categoryItem(categories[index]),
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

  Widget _categoryItem(String title) {
    return SizedBox(
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
          ),
        ],
      ),
    );
  }

  Widget _horizontalSection(String title, List<Map<String, String>> events) {
    final ScrollController scrollController = ScrollController();

    return Container(
      padding: const EdgeInsets.only(top: 20),
      color: const Color(0xFFCFFFFA),
      width: double.infinity,
      height: 330,
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Inter'),
                ),
                const Text('ALL', style: TextStyle(fontSize: 16, fontFamily: 'Inter')),
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
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const LearnMorePage()));
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
                              height: 120,
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
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text('By ${event['by']}',style: TextStyle(fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 2),
                                  Text('Course Start: ${event['start']}'),
                                  const SizedBox(height: 2),
                                  Text('Course End: ${event['end']}'),
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
