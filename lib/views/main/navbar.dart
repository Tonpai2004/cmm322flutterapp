import 'package:flutter/material.dart';

class ResponsiveNavbar extends StatelessWidget {
  final bool isMobile;
  final bool isMenuOpen;
  final VoidCallback toggleMenu;
  final VoidCallback goToHome;
  final VoidCallback? onMyCourses;
  final VoidCallback? onSupport;
  final VoidCallback? onLogin;
  final VoidCallback? onRegister;
  final bool isLoggedIn;
  final String? profileImagePath;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLogout;

  const ResponsiveNavbar({
    super.key,
    required this.isMobile,
    required this.isMenuOpen,
    required this.toggleMenu,
    required this.goToHome,
    this.onMyCourses,
    this.onSupport,
    this.onLogin,
    this.onRegister,
    required this.isLoggedIn,
    this.profileImagePath,
    this.onProfileTap,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          color: const Color(0xFF54EDDC),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Image.asset('assets/images/cmmlogo.png', height: 40),
              const SizedBox(width: 20),
              if (!isMobile) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 5.75),
                  child: _navButton('Home', onTap: goToHome),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.75),
                  child: _navButton('My Courses', onTap: onMyCourses),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.75),
                  child: _navButton('Support', onTap: onSupport),
                ),
                const Spacer(),
                if (!isLoggedIn) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: _actionButton('Login', onTap: onLogin),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: _actionButton('Register', onTap: onRegister),
                  ),
                ] else ...[
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'profile') {
                        onProfileTap?.call();
                      } else if (value == 'logout') {
                        onLogout?.call();
                      }
                    },
                    offset: const Offset(0, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: const Color(0xFF4CD1C2),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'profile',
                        child: Row(
                          children: const [
                            Icon(Icons.person, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Profile', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: const [
                            Icon(Icons.logout, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Logout', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                    child: CircleAvatar(
                      backgroundImage: profileImagePath != null
                          ? AssetImage(profileImagePath!)
                          : const AssetImage('assets/images/default_profile.png'),
                      radius: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ] else ...[
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.menu, size: 30),
                  onPressed: toggleMenu,
                ),
              ],
            ],
          ),
        ),

        // Mobile menu
        if (isMobile && isMenuOpen)
          Container(
            width: double.infinity,
            color: const Color(0xFF54EDDC),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                if (isLoggedIn) ...[
                  GestureDetector(
                    onTap: onProfileTap ?? goToHome,
                    child: CircleAvatar(
                      backgroundImage: profileImagePath != null
                          ? AssetImage(profileImagePath!)
                          : const AssetImage('assets/images/default_profile.png'),
                      radius: 30,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _actionButton('Logout', mobile: true, onTap: onLogout),
                ],
                _navButton('Home', mobile: true, onTap: goToHome),
                _navButton('My Courses', mobile: true, onTap: onMyCourses),
                _navButton('Support', mobile: true, onTap: onSupport),

                if (!isLoggedIn) ...[
                  const Divider(color: Colors.white),
                  _actionButton('Login', mobile: true, onTap: onLogin),
                  _actionButton('Register', mobile: true, onTap: onRegister),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _navButton(String text, {bool mobile = false, VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 12, vertical: mobile ? 8 : 0),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String text, {bool mobile = false, VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 8, vertical: mobile ? 8 : 0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF4CD1C2)),
          backgroundColor: const Color(0xFF4CD1C2),
          foregroundColor: Colors.white,
        ),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
