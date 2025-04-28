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
    GetMaterialApp(
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
  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/grayprofile.png';

  bool _ongoing = false;
  bool _upcoming = false;
  bool _iotDev = false;
  bool _animation = false;
  bool _production = false;
  bool _graphics = false;
  bool _business = false;
  bool _format = false;
  bool _talk = false;
  bool _thai = false;
  bool _english = false;

  bool _statusHeaderChecked = false;
  bool _subjectCategoriesHeaderChecked = false;
  bool _formatHeaderChecked = false;
  bool _languageHeaderChecked = false;

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _toggleStatus() {
    setState(() {
      _ongoing = !_ongoing;
      _upcoming = !_upcoming;
    });
  }

  void _toggleSubjectCategories() {
    setState(() {
      _iotDev = !_iotDev;
      _animation = !_animation;
      _production = !_production;
      _graphics = !_graphics;
      _business = !_business;
    });
  }

  void _toggleFormat() {
    setState(() {
      _format = !_format;
      _talk = !_talk;
    });
  }

  void _toggleLanguage() {
    setState(() {
      _thai = !_thai;
      _english = !_english;
    });
  }

  Widget _buildFilterOption(String title, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.05,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: Color(0xFF54EDDC),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, bool headerChecked, ValueChanged<bool?> onChanged) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF3FA099),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.1,
            child: Checkbox(
              value: headerChecked,
              onChanged: onChanged,
              activeColor: Color(0xFF54EDDC),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        if (user != null) {
          isLoggedIn = true;
          profilePath = 'assets/images/default_profile.jpg';
        } else {
          isLoggedIn = false;
          profilePath = 'assets/images/grayprofile.png';
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
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: _animationDuration,
              left: 0,
              top: 40,
              bottom: 0,
              width: sidebarWidth,
              child: Material(
                elevation: 20,
                color: Color(0xFF4BC0B2),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
                  child: ListView(
                    children: [
                      SizedBox(height: 50),
                      Center(
                        child: const Text(
                          'Filter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildHeader('Status', _statusHeaderChecked, (val) {
                        setState(() {
                          _statusHeaderChecked = val!;
                          _ongoing = val;
                          _upcoming = val;
                        });
                      }),
                      _buildFilterOption('Ongoing', _ongoing, (val) => setState(() => _ongoing = val!)),
                      _buildFilterOption('Upcoming', _upcoming, (val) => setState(() => _upcoming = val!)),
                      SizedBox(height: 10),

                      _buildHeader('Subject Categories', _subjectCategoriesHeaderChecked, (val) {
                        setState(() {
                          _subjectCategoriesHeaderChecked = val!;
                          _iotDev = val;
                          _animation = val;
                          _production = val;
                          _graphics = val;
                          _business = val;
                        });
                      }),
                      _buildFilterOption('IOT & DEV', _iotDev, (val) => setState(() => _iotDev = val!)),
                      _buildFilterOption('ANIMATION', _animation, (val) => setState(() => _animation = val!)),
                      _buildFilterOption('PRODUCTION', _production, (val) => setState(() => _production = val!)),
                      _buildFilterOption('GRAPHICS', _graphics, (val) => setState(() => _graphics = val!)),
                      _buildFilterOption('BUSINESS', _business, (val) => setState(() => _business = val!)),
                      SizedBox(height: 10),

                      _buildHeader('Format', _formatHeaderChecked, (val) {
                        setState(() {
                          _formatHeaderChecked = val!;
                          _format = val;
                          _talk = val;
                        });
                      }),
                      _buildFilterOption('Talk', _format, (val) => setState(() => _format = val!)),
                      _buildFilterOption('Talk & Workshop', _talk, (val) => setState(() => _talk = val!)),
                      SizedBox(height: 10),

                      _buildHeader('Language', _languageHeaderChecked, (val) {
                        setState(() {
                          _languageHeaderChecked = val!;
                          _thai = val;
                          _english = val;
                        });
                      }),
                      _buildFilterOption('Thai', _english, (val) => setState(() => _english = val!)),
                      _buildFilterOption('English', _thai, (val) => setState(() => _thai = val!)),
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
            top: 60,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.only(left: _isSidebarOpen ? sidebarWidth : 0), // บีบขนาดด้วย
              color: const Color(0xFFCFFFFA),
              child: Scaffold(
                backgroundColor: Colors.transparent, // อย่ากำหนดพื้นหลังใน Scaffold ซ้ำ
                body: StreamBuilder<List<WorkshopData>>(
                  stream: _workshopController.getWorkshops(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error fetching data'));
                    }

                    final workshops = snapshot.data; // Snapshot here

                    if (workshops == null || workshops.isEmpty) {
                      return const Center(child: Text('No workshops available'));
                    }

                    // Apply filter based on Subject Categories
                    final filteredWorkshops = workshops.where((workshop) {

                      // Date and Time of events //
                      if (_ongoing && workshop.endDate.contains('April')) {
                        return true;
                      }
                      if (_upcoming && !workshop.startDate.contains('April')) {
                        return true;
                      }
                      // Subject Categories //
                      if (_iotDev && workshop.code.toUpperCase().contains('DEV')) {
                        return true;
                      }
                      if (_animation && workshop.code.toUpperCase().contains('FLTR')) {
                        return true;
                      }
                      if (_production && workshop.code.toUpperCase().contains('PROD')) {
                        return true;
                      }
                      if (_graphics && workshop.code.toUpperCase().contains('GRAPH')) {
                        return true;
                      }
                      if (_business && workshop.code.toUpperCase().contains('BUSI')) {
                        return true;
                      }

                      // Format //
                      if ((_format && _talk) && !workshop.code.contains('FLTR')) {
                        return true;
                      }

                      // Language //
                      if (_thai && workshop.subject.contains('แอนิเมชัน')) {
                        return true;
                      }
                      if (_english && workshop.code.contains('Animation')) {
                        return true;
                      }

                      if (!_ongoing && !_upcoming && !_iotDev && !_animation && !_production && !_graphics && !_business && !_format && !_talk && !_thai && !_english) {
                        return true;
                      }

                      return false;

                    }).toList();

                    return ListView.builder(
                      itemCount: filteredWorkshops.length,
                      itemBuilder: (context, index) {
                        return _buildWorkshopCard(context, filteredWorkshops[index]);
                      },
                    );
                  },
                ),
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
          if (!_isMenuOpen)
            AnimatedPositioned(
              duration: _animationDuration,
              left: _isSidebarOpen ? sidebarWidth - 0 : 0,
              top: 130,

              child: FloatingActionButton(
                onPressed: _toggleSidebar,
                backgroundColor: const Color(0xFF4bc0b2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(0), right: Radius.circular(16)),
                ),
                child: Icon(_isSidebarOpen ? Icons.arrow_left : Icons.arrow_right, color: Colors.white, size: 30),
              ),
            ),

        ],
      ),
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
            width: 350,
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
