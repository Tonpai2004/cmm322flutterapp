import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'learnmore.dart';
import 'login.dart';
import 'mockup_profile.dart';
import '../main/coming_soon.dart';
import 'support_page.dart';
import 'navbar.dart';
import 'footer.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'Inter',
    ),
    home: SupportClipPage(),
  ));
}

class SupportClipPage extends StatefulWidget {
  const SupportClipPage({super.key});

  @override
  State<SupportClipPage> createState() => _SupportClipPageState();
}

class _SupportClipPageState extends State<SupportClipPage> {
  late YoutubePlayerController _ytController;
  bool _isMenuOpen = false;
  bool isLoggedIn = false;
  String profilePath = 'assets/images/Recording_room.jpg';

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('isLoggedIn');
    String? storedProfilePath = prefs.getString('profileImagePath');

    setState(() {
      isLoggedIn = loggedIn ?? false;
      if (storedProfilePath != null && storedProfilePath.isNotEmpty) {
        profilePath = storedProfilePath;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();

    const videoId = '4senIJ6TU_o';

    _ytController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        controlsVisibleAtStart: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _ytController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 876;

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _ytController,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFF2FFFE),
            body: Column(
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Home > Support > How to use',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: player,
                        ),
                      ],
                    ),
                  ),
                ),
                const Footer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
