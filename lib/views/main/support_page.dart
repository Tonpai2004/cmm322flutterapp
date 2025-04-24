import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'login.dart';
import 'navbar.dart';
import 'footer.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'Inter',
    ),
    home: const SupportPage(),
  ));
}

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/Recording_room.jpg';

  final TextEditingController _issueController = TextEditingController();

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

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    return Scaffold(
      backgroundColor: const Color(0xFFF3FFFE),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                    },
                    onLogout: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.remove('isLoggedIn');
                      setState(() {
                        isLoggedIn = false;
                      });
                    },
                  ),
                  // Support
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    decoration: const BoxDecoration(color: Color(0xFFCFFFFA)),
                    child: const Text(
                      'Support',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF212D61)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildExpansionTileBox(
                    context: context,
                    title: 'For the general public',
                    backgroundColor: const Color(0xFF4CD1C2),
                    titleTextColor: const Color(0xFF212D61),
                    contentTiles: [
                      _buildColoredTile('Unable to login'),
                      _buildColoredTile('User Access Guide'),
                      _buildColoredTile('Unable to locate the course in the system'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildExpansionTileBox(
                    context: context,
                    title: 'For students and staff',
                    backgroundColor: const Color(0xFF4CD1C2),
                    titleTextColor: const Color(0xFF212D61),
                    contentTiles: [
                      _buildColoredTile('Unable to login to your student or staff account'),
                      _buildColoredTile('The course registration system is experiencing issues.'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Report additional issues',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF212D61)),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _issueController,
                                decoration: const InputDecoration(
                                  hintText: 'Specify details...',
                                  filled: true,
                                  fillColor: Color(0xFFCFFFFA),
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Color(0xFF2865A5)),
                                ),
                                style: const TextStyle(color: Color(0xFF2865A5)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CD1C2),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onPressed: () {
                                if (_issueController.text.trim().isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Sent successfully.')),
                                  );
                                  _issueController.clear();
                                }
                              },
                              child: const Text(
                                'Send',
                                style: TextStyle(color: Color(0xFF212D61)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }

  // ExpansionTile Box
  Widget _buildExpansionTileBox({
    required BuildContext context,
    required String title,
    required Color backgroundColor,
    required List<Widget> contentTiles,
    Color titleTextColor = Colors.white,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.zero,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ExpansionTile(
          collapsedIconColor: titleTextColor,
          iconColor: titleTextColor,
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: titleTextColor,
              fontSize: 16,
            ),
          ),
          children: contentTiles,
        ),
      ),
    );
  }

  Widget _buildColoredTile(String text) {
    return Container(
      color: const Color(0xFFCFFFFA),
      child: ListTile(
        title: Text(
          text,
          style: const TextStyle(color: Color(0xFF212D61)),
        ),
      ),
    );
  }
}





