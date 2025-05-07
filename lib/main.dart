import 'package:contentpagecmmapp/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:contentpagecmmapp/firebase_options.dart';
import 'views/main/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    GetMaterialApp(  // ใช้ GetMaterialApp แทน MaterialApp
      theme: ThemeData(fontFamily: 'Inter'),
      home: SplashScreen(),  // หรือหน้าหลักที่คุณต้องการ
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Welcome',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryColor,
          primary: kDarkSecondaryColor,
        ),
      ),
      home: SplashScreen(),
    );
  }
}
