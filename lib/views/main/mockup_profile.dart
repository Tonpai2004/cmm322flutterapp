import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockProfilePage extends StatefulWidget {
  const MockProfilePage({super.key});

  @override
  State<MockProfilePage> createState() => _MockProfilePageState();
}

class _MockProfilePageState extends State<MockProfilePage> {
  String name = '';
  String studentId = '';
  String profileImagePath = 'assets/images/default_profile.png';

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'ไม่พบชื่อ'; // เพิ่มการดึงชื่อ
      studentId = prefs.getString('studentId') ?? 'ไม่พบรหัส';
      profileImagePath = prefs.getString('profileImagePath') ?? 'assets/images/default_profile.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลผู้ใช้'),
        backgroundColor: const Color(0xFF212D61),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(profileImagePath),
            ),
            const SizedBox(height: 20),
            Text(
              'ชื่อ: $name', // แสดงชื่อ
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'รหัสนักศึกษา: $studentId', // แสดงรหัสนักศึกษา
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
}
