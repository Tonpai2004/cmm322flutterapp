import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 5.0),
            const Text(
              'Department of Computer and Technology, \nFaculty of Industrial Education and Technology\n'
              "King Mongkut's University of Technology Thonburi\n"
              'Tel : 02-470-8500 | Email : orgcomit@kmutt.ac.th',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Divider(color: Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.globe, size: 35),
                  onPressed: () => _launchURL('https://cit.kmutt.ac.th/cmm23/'),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.facebook, size: 35),
                  onPressed: () => _launchURL('https://www.facebook.com/25thCMMKMUTT'),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.instagram, size: 35),
                  onPressed: () => _launchURL('https://www.instagram.com/cmm_kmutt/'),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.youtube, size: 35),
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
