import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Image.asset("assets/images/Background.png"),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.0001),
          
                const Text(  "\"To sustain the future\"", 
                  style: TextStyle(fontSize: 20,
                  fontStyle:FontStyle.italic ,
                  color: Colors.grey, 
                  fontWeight: FontWeight.bold),
          
                   ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          
                 const Text(  "CUSTOMER | BUYER | AI", 
                  style: TextStyle(fontSize: 20,
                  fontStyle:FontStyle.italic ,
                  color: Colors.grey, 
                  fontWeight: FontWeight.bold),
          
                   ),
          
          
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
