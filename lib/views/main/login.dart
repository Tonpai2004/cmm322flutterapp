import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contentpagecmmapp/views/main/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'enroll mobile.dart';
import 'enrolled.dart';
import 'homepage.dart';
import 'support_page.dart';
import 'navbar.dart';
import '../../controllers/auth_controller.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(fontFamily: 'Inter'),
      home: LoginRegisterPage(),
    ),
  );
}

class LoginRegisterPage extends StatefulWidget {
  final bool showLogin;
  final bool showRegister;

  const LoginRegisterPage({
    super.key,
    this.showLogin = false,
    this.showRegister = false,
  });

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  bool showLoginForm = false;
  bool showRegisterForm = false;
  bool isButtonPressed = false;

  final AuthController authController = AuthController();

  // This is for navigation bar //
  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/grayprofile.png';

  final Color defaultColor = const Color(0xFF54EDDC);
  final Color pressedColor = const Color(0xFF4CD1C2);

  String buttonText = "Log In";

  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController regNameController = TextEditingController();
  final TextEditingController regStudentIdController = TextEditingController();
  final TextEditingController regPasswordController = TextEditingController();
  final TextEditingController regConfirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();

    // ตรวจสอบสถานะผู้ใช้เมื่อเริ่มต้น
    final user = authController.currentUser;
    setState(() {
      isLoggedIn = user != null;
      profilePath = user != null
          ? 'assets/images/default_profile.jpg'
          : 'assets/images/grayprofile.png';

      // เปลี่ยนปุ่มตามสถานะการเข้าสู่ระบบ
      if (widget.showRegister) {
        buttonText = "Register";  // ถ้าแสดงฟอร์มลงทะเบียน ให้แสดง "Register"
      } else {
        buttonText = user != null ? "Log Out" : "Log In";  // ถ้าไม่มีการแสดงฟอร์มลงทะเบียนให้แสดงตามสถานะการเข้าสู่ระบบ
      }
    });

    // ฟังการเปลี่ยนแปลงสถานะการล็อกอิน
    authController.authStateChanges.listen((user) {
      setState(() {
        isLoggedIn = user != null;
        profilePath = user != null
            ? 'assets/images/default_profile.jpg'
            : 'assets/images/grayprofile.png';
        // เปลี่ยนปุ่มตามสถานะการเข้าสู่ระบบ
        if (widget.showRegister) {
          buttonText = "Register";  // ถ้าแสดงฟอร์มลงทะเบียน ให้แสดง "Register"
        } else {
          buttonText = user != null ? "Log Out" : "Log In";  // ถ้าไม่มีการแสดงฟอร์มลงทะเบียนให้แสดงตามสถานะการเข้าสู่ระบบ
        }
      });
    });

    // กำหนดค่าเริ่มต้นให้ showLoginForm และ showRegisterForm
    showLoginForm = widget.showLogin;
    showRegisterForm = widget.showRegister;
  }

  void checkLoginStatus() async {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        if (user != null) {
          isLoggedIn = true;
          _loadUserProfile(user.uid); // เปลี่ยนเป็นรูปโปรไฟล์เมื่อ login
        } else {
          isLoggedIn = false;
          profilePath = 'assets/images/default_profile.jpg'; // รูปที่ใช้ตอนไม่ได้ล็อกอิน
        }
      });
    });
  }

  Future<void> _loadUserProfile(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('students').doc(userId).get();
    if (doc.exists) {
      final data = doc.data();
      setState(() {
        profilePath = data?['profileImagePath'] ?? 'assets/images/grayprofile.png';
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    return Scaffold(
      backgroundColor: const Color(0xFFF3FFFE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ResponsiveNavbar(
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
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                ).then((updatedImagePath) {
                  if (updatedImagePath != null) {
                    setState(() {
                      profilePath = updatedImagePath;  // อัพเดตรูปโปรไฟล์ที่นี่
                    });
                  }
                });
              },
              onLogout: () async {
                await FirebaseAuth.instance.signOut();
                setState(() {
                  isLoggedIn = false;
                });
              },
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildToggleButton(
                        title: 'LOGIN',
                        isSelected: showLoginForm,
                        onTap: () {
                          setState(() {
                            showLoginForm = !showLoginForm;
                            showRegisterForm = false;
                            buttonText = "Log In";
                          });
                        },
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      if (showLoginForm) _buildLoginForm(),
                      _buildToggleButton(
                        title: 'Register',
                        isSelected: showRegisterForm,
                        onTap: () {
                          setState(() {
                            showRegisterForm = !showRegisterForm;
                            showLoginForm = false;
                            buttonText = "Register";
                          });
                        },
                        borderRadius:
                            showRegisterForm
                                ? BorderRadius.zero
                                : const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                      ),
                      if (showRegisterForm) _buildRegisterForm(),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 40),
                        child: Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTapDown: (_) {
                              setState(() {
                                isButtonPressed = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                isButtonPressed = false;
                              });
                            },
                            onTap: () async {
                              setState(() {
                                isButtonPressed = false;
                              });

                              if (buttonText == "Register") {
                                if (regPasswordController.text !=
                                    regConfirmPasswordController.text) {
                                  _showDialog("Password mismatch");
                                  return;
                                }

                                String? errorMessage = await authController
                                    .register(
                                      name: regNameController.text,
                                      studentId: regStudentIdController.text,
                                      password: regPasswordController.text,
                                    );

                                if (errorMessage != null) {
                                  _showDialog(errorMessage);
                                } else {
                                  _showDialog("Register Success!");
                                }
                              } else {
                                String? errorMessage = await authController
                                    .login(
                                      studentId: studentIdController.text,
                                      password: passwordController.text,
                                    );

                                if (errorMessage != null) {
                                  _showDialog(errorMessage);
                                } else {
                                  setState(() {
                                    isLoggedIn = true;
                                    profilePath =
                                        'assets/images/default_profile.jpg'; // ใช้ default ไปก่อน
                                  });

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HomePage(),
                                    ),
                                  );
                                }
                              }
                            },

                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    isButtonPressed
                                        ? pressedColor
                                        : defaultColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 80,
                                vertical: 20,
                              ),
                              child: Text(
                                buttonText,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF212D61),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required BorderRadius borderRadius,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? pressedColor : defaultColor,
          borderRadius: borderRadius,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              fontSize: 20,
              color: Color(0xFF212D61),
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFCFFFFA),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10),
          const Center(
            child: Text(
              'Fill in information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 8),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _styledTextField(
              'Student ID',
              controller: studentIdController,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _styledTextField(
              'Password',
              obscure: true,
              controller: passwordController,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFCFFFFA),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10),
          const Center(
            child: Text(
              'Fill in information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 8),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _styledTextField('Name', controller: regNameController),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _styledTextField(
              'Student ID',
              controller: regStudentIdController,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _styledTextField(
              'Password',
              obscure: true,
              controller: regPasswordController,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _styledTextField(
              'Confirm Password',
              obscure: true,
              controller: regConfirmPasswordController,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _styledTextField(
    String hint, {
    bool obscure = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF54EDDC), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: const Color(0xFF4CD1C2), width: 2),
        ),
      ),
    );
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
