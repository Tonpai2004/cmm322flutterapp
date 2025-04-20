import 'package:flutter/material.dart';
import 'homepage.dart';
import 'navbar.dart';

class LearnMorePage extends StatefulWidget {
  const LearnMorePage({super.key});

  @override
  State<LearnMorePage> createState() => _LearnMorePageState();
}

class _LearnMorePageState extends State<LearnMorePage> {
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
                      child: Text(
                        'This is the Learn More Page.\nใส่รายละเอียดเพิ่มเติมเกี่ยวกับ CMM ที่นี่',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
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
