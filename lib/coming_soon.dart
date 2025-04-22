import 'package:flutter/material.dart';
import 'homepage.dart';
import 'navbar.dart';

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
                  onLogin: () {},
                  onRegister: () {},
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
