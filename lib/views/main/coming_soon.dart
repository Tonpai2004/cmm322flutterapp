import 'package:flutter/material.dart';
import '../main/homepage.dart';
import '../main/learnmore.dart';
import '../main/navbar.dart';

void main() {
  runApp(const MaterialApp(home: ComingSoon()));
}

class ComingSoon extends StatefulWidget {
  const ComingSoon({super.key});

  @override
  State<ComingSoon> createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  bool _isMenuOpen = false;

  bool isLoggedIn = false;
  String profilePath = 'assets/images/Recording_room.jpg';

  @override
  Widget build(BuildContext context) {
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
                  onSupport: () {},
                  onLogin: () => setState(() => isLoggedIn = true),
                  onRegister: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LearnMorePage())); // Will change it later //
                  },
                  isLoggedIn: isLoggedIn, // true / false
                  profileImagePath: profilePath, // เช่น 'assets/images/user_avatar.jpg'
                  onProfileTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                  },
                  onLogout: () => setState(() => isLoggedIn = false),
                ),

                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            size: 160,
                            color: Colors.orangeAccent,
                          ),
                          const SizedBox(height: 0),
                          const Text(
                            'Coming Soon.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                          ),
                        ],
                      ),
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
}
