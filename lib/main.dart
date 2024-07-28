import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_market/components/bottom_bar.dart';

import 'package:green_market/screens/splash_screen.dart';
import 'package:green_market/screens/login_screen.dart';
import 'package:green_market/screens/signin_screen.dart';



void main() {
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:Signin(),
    );
  }
}
