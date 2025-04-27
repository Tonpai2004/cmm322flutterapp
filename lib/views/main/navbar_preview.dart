import 'package:flutter/material.dart';
import '../main/homepage.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง ลิงก์หน้าHome มาจากไฟล์นี้ //
import '../main/navbar.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง Navbar มาจากไฟล์นี้ //
import '../main/learnmore.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง Navbar มาจากไฟล์นี้ //
import '../main/footer.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง Footer มาจากไฟล์นี้ //

void main() {
  runApp(const MaterialApp(home: NavbarPreview()));
}

class NavbarPreview extends StatefulWidget {
  const NavbarPreview({super.key});

  @override
  State<NavbarPreview> createState() => _NavbarPreviewState();
}

class _NavbarPreviewState extends State<NavbarPreview> {

  // เอาไว้เช็คค่าสถานะว่าแท็บ Menu ได้เปิดไปหรือไม่ อย่าลืมเอาไปใส่ด้วย //
  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/grayprofile.png';

  @override
  Widget build(BuildContext context) {

    // 2อันนี้เอาไว้วัดขนาดหน้าจอ อย่าลืมเอาไปใส่ในไฟล์ด้วย จะได้ Responsive menu ของ Navbar ได้ถูกต้อง //
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    return Scaffold(
      backgroundColor: const Color(0xFFCFFFFA),
      body: SafeArea(
        child: Column(
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

            const Spacer(),
            const Footer(), // ตัวนี้เป็นการเรียกใช้งาน Footer ที่สร้างไว้แล้ว แค่เอามาวางในไฟล์พอสำหรับหน้าไหนที่ใช้งาน Footer //
          ],
        ),
      ),
    );
  }
}
