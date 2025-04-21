import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  // เพิ่มฟังก์ชัน _launchURL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF54EDDC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // จัดให้อยู่กลางในแนวตั้ง
          crossAxisAlignment: CrossAxisAlignment.center, // จัดให้อยู่กลางในแนวนอน
          children: [
            SizedBox(height: 20.0),
            const Text(
              'Department of Computer and Technology, Faculty of Industrial Education and Technology\n'
                  "Integrated Building 3 (S13), 6th Floor, King Mongkut's University of Technology Thonburi\n"
                  'Tel : 02-470-8500 | Email : orgcomit@kmutt.ac.th',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center, // จัดข้อความให้อยู่กลาง
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // จัดให้ปุ่มในแถวอยู่กลาง
              children: [
                IconButton(
                  icon: const Icon(Icons.facebook, size: 40),
                  onPressed: () => _launchURL('https://www.facebook.com/25thCMMKMUTT'),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.play_circle_fill, size: 40),
                  onPressed: () => _launchURL('https://www.youtube.com/@CMMKMUTT'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
