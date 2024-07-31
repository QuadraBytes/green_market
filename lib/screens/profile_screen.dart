import 'package:flutter/material.dart';
import 'package:green_market/components/constants.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> crops = ["vrevw", 'rvrev', 'ewqdew'];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: -10, child: Image.asset('assets/images/appbar2.png')),
          Positioned(
              top: 50,
              left: 10,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
          Positioned(
            top: 60,
            left: size.width * 0.4,
            right: size.width * 0.4,
            child: Text('Profile',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/profile.png',
                  height: size.height * 0.1,
                ),
                SizedBox(height: 10),
                Text(
                  'Saman Bandara',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.red),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Digana, Kandy',
                      style: TextStyle(
                        fontSize: 16,
                        color: kColor3,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: Colors.red),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '+94 XX XXX XXXX',
                      style: TextStyle(
                        fontSize: 16,
                        color: kColor3,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', // Replace with actual description
                    textAlign: TextAlign.justify,

                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Crops',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 17.5),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: crops.map((crop) {
                        return Chip(
                          labelStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                          color: WidgetStateProperty.all(
                              Color.fromRGBO(86, 232, 137, 1)),
                          label: Text(crop),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kColor,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kColor3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
