import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../enrolled.dart';
import 'homepage.dart';
import 'mockup_profile.dart';
import 'support_page.dart';
import 'navbar.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter',
      ),
      home: LoginRegisterPage()));
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

  // This is for navigation bar //
  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/Recording_room.jpg';

  final Color defaultColor = const Color(0xFF54EDDC);
  final Color pressedColor = const Color(0xFF4CD1C2);

  String buttonText = "Log In";

  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController regNameController = TextEditingController();
  final TextEditingController regStudentIdController = TextEditingController();
  final TextEditingController regPasswordController = TextEditingController();
  final TextEditingController regConfirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLoginStatus();
    showLoginForm = widget.showLogin;
    showRegisterForm = widget.showRegister;
    buttonText = widget.showLogin ? "Log In" : (widget.showRegister ? "Register" : "Log In");
  }

  void _loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    final storedProfilePath = prefs.getString('profileImagePath') ?? 'assets/images/default_profile.png';
    setState(() {
      isLoggedIn = loggedIn;
      profilePath = storedProfilePath;
    });
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
              onMyCourses: () {
                setState(() => _isMenuOpen = false);
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
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('isLoggedIn');
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
                        borderRadius: showRegisterForm
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
                              final prefs = await SharedPreferences.getInstance();

                              if (buttonText == "Register") {
                                if (regPasswordController.text != regConfirmPasswordController.text) {
                                  _showDialog("Password ไม่ตรงกัน");
                                  return;
                                }
                                await prefs.setString('name', regNameController.text);
                                await prefs.setString('studentId', regStudentIdController.text);
                                await prefs.setString('password', regPasswordController.text);
                                await prefs.setString('profileImagePath', 'assets/images/default_profile.png');
                                _showDialog("Register Success!");
                              } else {
                                final storedId = prefs.getString('studentId');
                                final storedPass = prefs.getString('password');
                                if (studentIdController.text == storedId && passwordController.text == storedPass) {
                                  setState(() {
                                    isLoggedIn = true;
                                    profilePath = 'assets/images/default_profile.png'; // ตั้ง default profile
                                  });
                                  await prefs.setBool('isLoggedIn', true);
                                  await prefs.setString('profileImagePath', profilePath); // บันทึกลง prefs ด้วย
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
                                } else {
                                  _showDialog("StudentID or Password is not correct, try again");
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isButtonPressed ? pressedColor : defaultColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                              child: Text(
                                buttonText,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF212D61)),
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
            )
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
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
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
            child: _styledTextField('Student ID', controller: studentIdController),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _styledTextField('Password', obscure: true, controller: passwordController),
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
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
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
            child: _styledTextField('Student ID', controller: regStudentIdController),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _styledTextField('Password', obscure: true, controller: regPasswordController),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _styledTextField('Confirm Password', obscure: true, controller: regConfirmPasswordController),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _styledTextField(String hint, {bool obscure = false, TextEditingController? controller}) {
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