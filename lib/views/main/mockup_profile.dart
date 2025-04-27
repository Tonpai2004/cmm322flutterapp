import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MockProfilePage extends StatefulWidget {
  const MockProfilePage({super.key});

  @override
  State<MockProfilePage> createState() => _MockProfilePageState();
}

class _MockProfilePageState extends State<MockProfilePage> {
  String name = '';
  String studentId = '';
  String profileImagePath = 'assets/images/default_profile.jpg';
  String email = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
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
            name = data?['name'] ?? 'ไม่พบชื่อ';
            studentId = data?['studentId'] ?? 'ไม่พบรหัส';
            profileImagePath = data?['profileImagePath'] ?? 'assets/images/default_profile.jpg';
            email = data?['email'] ?? 'ไม่พบอีเมล';
            isLoading = false;
          });
        } else {
          setState(() {
            name = 'ไม่พบข้อมูล';
            studentId = '-';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user info: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลผู้ใช้'),
        backgroundColor: const Color(0xFF212D61),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: _getProfileImage(),
            ),
            const SizedBox(height: 20),
            Text(
              'ชื่อ: $name',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'รหัสนักศึกษา: $studentId',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'อีเมล: $email',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ย้อนกลับ'),
            ),
          ],
        ),
      ),
    );
  }

  /// ฟังก์ชันเช็กว่ารูปเป็น URL หรือเป็น asset
  ImageProvider _getProfileImage() {
    if (profileImagePath.startsWith('http') || profileImagePath.startsWith('https')) {
      return NetworkImage(profileImagePath);
    } else {
      return AssetImage(profileImagePath);
    }
  }
}
