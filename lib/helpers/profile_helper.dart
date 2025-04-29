import 'package:shared_preferences/shared_preferences.dart';

Future<String> getProfileImagePath() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('profileImage') ?? 'assets/images/avatar1.png';
}
