import 'package:flutter/material.dart';
import 'homepage.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง ลิงก์หน้าHome มาจากไฟล์นี้ //
import 'navbar.dart'; // Import เข้ามาด้วยเนื่องจากต้องดึง Navbar มาจากไฟล์นี้ //
import 'footer.dart';

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
              onLogin: () {},
              onRegister: () {},
            ),
            const Spacer(),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
