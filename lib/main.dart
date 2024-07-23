import 'package:flutter/material.dart';
import 'package:green_market/screens/splash_screen.dart';

void main() {
  runApp(const GreenMarket());
}

class GreenMarket extends StatelessWidget {
  const GreenMarket({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Green Market',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: SplashScreen(),
    );
  }
}

