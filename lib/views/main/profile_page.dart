import 'dart:async';
import 'dart:ui' as ui;

import 'package:contentpagecmmapp/views/main/support_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'change_password_dialog.dart';
import 'enroll mobile.dart';
import 'enrolled.dart';
import 'homepage.dart';
import 'login.dart';
import 'navbar.dart';
import 'profile_image_selector.dart';
import "package:auto_size_text/auto_size_text.dart";

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String? profilePath = 'assets/images/default_profile.jpg';

  String currentImagePath = 'assets/images/avatar1.png';
  bool isLoading = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    _loadUserDataFromFirebase();
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

  Future<void> _loadUserDataFromFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('students')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          final data = doc.data();
          setState(() {
            currentImagePath = data?['profileImagePath'] ?? 'assets/images/avatar1.png';
            nameController.text = data?['name'] ?? '';
            emailController.text = data?['email'] ?? '';
            studentIdController.text = data?['studentId'] ?? '';
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading data from Firebase: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> _saveUserData() async {
    if (_anyFieldEmpty()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();

    // บันทึกข้อมูลใน Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('students').doc(user.uid).set({
        'profileImagePath': currentImagePath,
        'name': nameController.text,
        'email': emailController.text,
        'studentId': studentIdController.text,
      }, SetOptions(merge: true)); // ใช้ merge เพื่อไม่ให้ข้อมูลเก่าถูกลบ

      // บันทึกข้อมูลใน SharedPreferences
      await prefs.setString('profileImagePath', currentImagePath);
      await prefs.setString('name', nameController.text);
      await prefs.setString('email', emailController.text);
      await prefs.setString('studentId', studentIdController.text);

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );
    }
  }



  bool _anyFieldEmpty() {
    return nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        studentIdController.text.trim().isEmpty;
  }

  void _openImageSelector() {
    showDialog(
      context: context,
      builder: (_) => ProfileImageSelector(
        selectedImage: currentImagePath,
        onImageSelected: (selectedPath) {
          setState(() => currentImagePath = selectedPath);
          _saveUserData();
        },
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showStudentIdDialog(
      BuildContext context,
      TextEditingController nameController,
      TextEditingController studentIdController,
      ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: FutureBuilder<Size>(
          future: _getImageSize('assets/images/student_card.png'),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('Error loading image'));
            }

            Size imageSize = snapshot.data!;
            double fixedWidth = 300;
            double scaledHeight = (fixedWidth / imageSize.width) * imageSize.height;

            double nameLeft = 90;
            double nameTop = scaledHeight * 0.66;

            double idLeft = 125;
            double idTop = scaledHeight * 0.68;

            return Center(
              child: Container(
                width: fixedWidth,
                height: scaledHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.transparent,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/student_card.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                      left: nameLeft,
                      top: nameTop,
                      child: Transform.rotate(
                        angle: -90 * 3.14159 / 180,
                        child: SizedBox(
                          width: 150,
                          child: AutoSizeText(
                            nameController.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            minFontSize: 8,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: idLeft,
                      top: idTop,
                      child: Transform.rotate(
                        angle: -90 * 3.14159 / 180,
                        child: SizedBox(
                          width: 120,
                          child: AutoSizeText(
                            studentIdController.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            minFontSize: 8,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<Size> _getImageSize(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return Size(frame.image.width.toDouble(), frame.image.height.toDouble());
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg-new.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildAvatarWithEdit(),
                        const SizedBox(height: 30),
                        _buildEditableField('NAME', nameController),
                        _buildEditableField('EMAIL', emailController),
                        _buildEditableField('STUDENT ID', studentIdController),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.badge),
                          label: const Text('STUDENT ID CARD'),
                          onPressed: () {
                            _showStudentIdDialog(context, nameController, studentIdController);
                          },
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => const ChangePasswordDialog(),
                            );
                          },
                          child: const Text('CHANGE PASSWORD'),
                        ),
                        const SizedBox(height: 10),

                        // >>>>> ตรงนี้เปลี่ยน onPressed ให้แล้ว <<<<<
                        OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                            await _saveUserData();
                            Navigator.pop(context, currentImagePath); // ส่ง path รูปกลับ
                          },
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text('SAVE PROFILE 💾'),
                        ),


                        const SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: _logout,
                          child: const Text('LOG OUT ↩'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(child: ResponsiveNavbar(
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
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarWithEdit() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                // เช็คว่าเป็น URL หรือไม่
                image: currentImagePath.startsWith('http') || currentImagePath.startsWith('https')
                    ? NetworkImage(currentImagePath)
                    : AssetImage(currentImagePath) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _openImageSelector,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildBottomSheetMenu() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              _logout();
            },
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
          child: const Text('Go to Profile Page'),
        ),
      ),
    );
  }
}
