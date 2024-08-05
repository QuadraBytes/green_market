import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_market/components/bottom_bar.dart';
import 'package:green_market/components/constants.dart';
import 'package:green_market/screens/availability_screen.dart';
import 'package:green_market/screens/favourites_screen.dart';
import 'package:green_market/screens/profile_screen.dart';
import 'package:green_market/screens/splash_screen.dart';
import 'package:green_market/screens/login_screen.dart';
import 'package:green_market/screens/signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBJUNKdSZCJ7wp2Z7suoLZTleLfQxZUl7E",
            authDomain: "green-market-4.firebaseapp.com",
            projectId: "green-market-4",
            storageBucket: "green-market-4.appspot.com",
            messagingSenderId: "750742413285",
            appId: "1:750742413285:web:bd03d8351ccfbaa515190c"));
  } else {
    await Firebase.initializeApp();
  }

  // runApp(const GreenMarket());
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const GreenMarket(),
    ),
  );
}

class GreenMarket extends StatelessWidget {
  const GreenMarket({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Green Market',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: kColor),
      //   useMaterial3: true,
      // ),
      home: BottomBarScreen(),
    );
  }
}
