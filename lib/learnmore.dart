import 'package:flutter/material.dart';

import 'homepage.dart';

class LearnMorePage extends StatefulWidget {
  const LearnMorePage({super.key});

  @override
  State<LearnMorePage> createState() => _learnMorePageState();
}

class _learnMorePageState extends State<LearnMorePage> {
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    return Scaffold(
      backgroundColor: const Color(0xFFCFFFFA),
      body: SafeArea(child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 60,
                color: const Color(0xFF54EDDC),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Image.asset('assets/images/cmmlogo.png', height: 40),
                    const SizedBox(width: 20),
                    if (!isMobile) ...[
                      Padding(
                        padding: EdgeInsets.only(top: 5.75),
                        child: _navButton('Home', onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        }),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.75),
                        child: _navButton('My Courses'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.75),
                        child: _navButton('Support'),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: _actionButton('Login'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: _actionButton('Register'),
                      ),
                    ] else ...[
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.menu, size: 30),
                        onPressed: () {
                          setState(() => _isMenuOpen = !_isMenuOpen);
                        },
                      ),
                    ],
                  ],
                ),
              ),
              // Content for Learn More page goes here
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      'This is the Learn More Page.\nใส่รายละเอียดเพิ่มเติมเกี่ยวกับ CMM ที่นี่',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Mobile menu overlay
          if (isMobile)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: _isMenuOpen ? 60 : -MediaQuery.of(context).size.height,
              left: 0,
              right: 0,
              child: Container(
                color: const Color(0xFF54EDDC),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    _navButton('Home', mobile: true, onTap: () { // HomePage Link Access
                      setState(() => _isMenuOpen = false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    }),
                    _navButton('My Courses', mobile: true),
                    _navButton('Support', mobile: true),
                    const Divider(color: Colors.white),
                    _actionButton('Login', mobile: true),
                    _actionButton('Register', mobile: true),
                  ],
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }

  Widget _navButton(String text, {bool mobile = false, VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 12, vertical: mobile ? 8 : 0),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String text, {bool mobile = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 8, vertical: mobile ? 8 : 0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF4CD1C2)),
          backgroundColor: Color(0xFF4CD1C2),
          foregroundColor: Colors.white,
        ),
        onPressed: () {},
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
