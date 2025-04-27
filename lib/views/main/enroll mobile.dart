import 'package:contentpagecmmapp/views/main/maincontent.dart';
import 'package:contentpagecmmapp/views/main/support_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../../controllers/workshop_controller.dart';
import '../../firebase_options.dart';
import 'enrolled.dart';
import 'homepage.dart';
import 'enroll.dart';
import 'login.dart';
import 'mockup_profile.dart';
import 'navbar.dart';

class WorkshopData {
  final String subject;
  final String code;
  final String startDate;
  final String endDate;
  final String imageUrl;

  WorkshopData({
    required this.subject,
    required this.code,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    GetMaterialApp(  // ใช้ GetMaterialApp แทน MaterialApp
      theme: ThemeData(fontFamily: 'Inter'),
      home: EnrollMobile(),
    ),
  );
}

class EnrollMobile extends StatefulWidget {
  const EnrollMobile({super.key});

  @override
  _EnrollMobileState createState() => _EnrollMobileState();
}

class _EnrollMobileState extends State<EnrollMobile> {
  final WorkshopController _workshopController = WorkshopController();

  final double sidebarWidth = 250;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  bool _isSidebarOpen = false;
  bool _option1 = true;
  bool _option2 = false;

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/grayprofile.png';

  @override
  void initState() {
    super.initState();

    // ฟังการเปลี่ยนแปลงของสถานะผู้ใช้จาก Firebase
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
      body: Stack(
        children: [
          // Sidebar
          AnimatedPositioned(
            duration: _animationDuration,
            left: _isSidebarOpen ? 0 : -sidebarWidth,
            top: 0,
            bottom: 0,
            width: sidebarWidth,
            child: Material(
              elevation: 16,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filter', style: TextStyle(fontSize: 24, color: Colors.white)),
                    const SizedBox(height: 20),
                    CheckboxListTile(
                      title: const Text("Status", style: TextStyle(color: Colors.white)),
                      value: _option1,
                      onChanged: (bool? value) {
                        setState(() {
                          _option1 = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("Ended", style: TextStyle(color: Colors.white)),
                      value: _option2,
                      onChanged: (bool? value) {
                        setState(() {
                          _option2 = value ?? false;
                        });
                      },
                    ),
                    // ... (other filter options here)
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          AnimatedPositioned(
            duration: _animationDuration,
            left: _isSidebarOpen ? sidebarWidth : 0,
            right: 0,
            top: 80,
            bottom: 0,
            child: Scaffold(
              backgroundColor: const Color(0xFFCFFFFA),
              body: StreamBuilder<List<WorkshopData>>(
                stream: _workshopController.getWorkshops(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching data'));
                  }

                  final workshops = snapshot.data;

                  if (workshops == null || workshops.isEmpty) {
                    return const Center(child: Text('No workshops available'));
                  }

                  return ListView.builder(
                    itemCount: workshops.length,
                    itemBuilder: (context, index) {
                      return _buildWorkshopCard(context, workshops[index]);
                    },
                  );
                },
              ),
            ),
          ),

          // Add Responsive Navbar here
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ResponsiveNavbar(
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
          ),

          // Floating Button to Open/Close Sidebar
          AnimatedPositioned(
            duration: _animationDuration,
            left: _isSidebarOpen ? sidebarWidth - 30 : 10,
            top: 130,
            child: FloatingActionButton(
              onPressed: _toggleSidebar,
              backgroundColor: Color(0xFF54EDDC),
              child: const Icon(Icons.arrow_right, color: Colors.white, size: 55),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildWorkshopCard(BuildContext context, WorkshopData data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            // Handle onTap here
            // For example, navigate to a detail page:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Enroll(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(30),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color(0xffbdece7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          data.imageUrl, // ใส่ URL ของภาพที่ได้จาก data.imageUrl
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      const SizedBox(height: 0),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFF54eddc),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.subject,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Course Code: ${data.code}'),
                            Text('Course Start Date: ${data.startDate}'),
                            Text('Course End Date: ${data.endDate}'),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4BC0B2),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('activity hours'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
