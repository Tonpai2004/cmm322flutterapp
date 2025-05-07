import 'package:flutter/material.dart';
import 'navbar.dart';

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: ResponsiveNavbar(
          isMobile: isMobile,
          isMenuOpen: true, // เพราะจะโชว์ใน bottom sheet อยู่แล้ว
          toggleMenu: () => Navigator.pop(context), // กดเมนูแล้วปิด bottom sheet
          goToHome: () {
            Navigator.pushNamed(context, '/home'); // หรือแล้วแต่การตั้ง route
          },
          onMyCourses: () {
            Navigator.pushNamed(context, '/mycourses');
          },
          onSupport: () {
            Navigator.pushNamed(context, '/support');
          },
          onLogin: () {
            Navigator.pushNamed(context, '/login');
          },
          onRegister: () {
            Navigator.pushNamed(context, '/register');
          },
          isLoggedIn: false, // หรือไปเช็ค shared_pref ก็ได้
          profileImagePath: null, // หรือ path จาก prefs
          onProfileTap: () {
            Navigator.pushNamed(context, '/profile');
          },
          onLogout: () {
            // ล็อกเอาท์
          },
        ),
      ),
    );
  }
}
