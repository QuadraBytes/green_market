import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_market/components/bottom_bar.dart';
import 'package:green_market/components/constants.dart';
import 'package:green_market/screens/login_screen.dart';
import 'package:green_market/screens/profile_edit_screen.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

late User? loggedInUser;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  String? displayName;
  String? about;
  String? phoneNumber;
  String? district;
  // List<String> crops = ["vrevw", 'rvrev', 'ewqdew'];
  List crops = [];
  List requirements = [];

  // bool isBuyerMode = false;

  // Future<void> loadModeState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     isBuyerMode = prefs.getBool('isBuyerMode') ?? false;
  //   });
  // }

  // void saveModeState(bool isBuyerMode) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isBuyerMode', isBuyerMode);
  // }

  Future<void> getUserData() async {
    loggedInUser = _auth.currentUser!;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(loggedInUser?.email)
        .get();

    var cropList = await FirebaseFirestore.instance.collection('crops').get();
    var requirementList =
        await FirebaseFirestore.instance.collection('requirements').get();

    for (var crop in cropList.docs) {
      if (crop['userId'] == loggedInUser?.uid) {
        crops.add(crop);
      }
    }

    for (var requirement in requirementList.docs) {
      if (requirement['userId'] == loggedInUser?.uid) {
        requirements.add(requirement);
      }
    }

    setState(() {
      displayName = userSnapshot['displayName'].toString();
      about = userSnapshot['about'].toString();
      phoneNumber = userSnapshot['phoneNumber'].toString();
      district = userSnapshot['district'].toString();
    });
  }

  void logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
                top: -50, child: Image.asset('assets/images/appbar2.png')),
            Positioned(
                top: 20,
                left: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomBarScreen()));
                  },
                )),
            Positioned(
              top: 25,
              left: size.width * 0.4,
              right: size.width * 0.4,
              child: Text('Profile',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            displayName == null
                ? Center(
                    child: CircularProgressIndicator(
                      color: kColor,
                    ),
                  )
                : Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/profile.png',
                            height: size.height * 0.1,
                          ),
                          SizedBox(height: 10),
                          Text(
                            displayName ?? 'Name',
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
                                district ?? 'District',
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
                                phoneNumber ?? 'Phone Number',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: kColor3,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Text(
                          //       "Farmer mode",
                          //       style: TextStyle(
                          //         fontSize: size.height * 0.0175,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.black,
                          //       ),
                          //     ),
                          //     SizedBox(width: 5),
                          //     Switch(
                          //       value: isBuyerMode,
                          //       onChanged: (value) {
                          //         setState(() {
                          //           isBuyerMode = value;
                          //           saveModeState(isBuyerMode);
                          //         });
                          //       },
                          //       trackColor: WidgetStatePropertyAll(kColor),
                          //       trackOutlineColor: WidgetStatePropertyAll(kColor),
                          //       inactiveThumbColor: Colors.white,
                          //     ),
                          //     SizedBox(width: 5),
                          //     Text(
                          //       "Buyer mode",
                          //       style: TextStyle(
                          //         fontSize: size.height * 0.0175,
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.black,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                'About',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.5),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              about ??
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', // Replace with actual description
                              textAlign: TextAlign.justify,

                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
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
                            child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: List<Widget>.generate(crops.length,
                                    (index) {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Card(
                                      color: crops[index]['isAccepted']
                                          ? Color.fromARGB(121, 255, 235, 50)
                                          : crops[index]['isExpired']
                                              ? Color.fromARGB(68, 244, 67, 50)
                                              : const Color.fromARGB(
                                                  92, 76, 175, 50),
                                      elevation: 0,
                                      margin:
                                          EdgeInsets.only(left: 0, right: 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              crops[index]['isAccepted']
                                                  ? 'Accepted'
                                                  : crops[index]['isExpired']
                                                      ? 'Expired'
                                                      : 'Available',
                                              style: TextStyle(
                                                color: crops[index]
                                                        ['isAccepted']
                                                    ? Colors.amber[700]
                                                    : crops[index]['isExpired']
                                                        ? Colors.red
                                                        : const Color.fromARGB(
                                                            255, 70, 170, 74),
                                                fontSize: size.height * 0.015,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              crops[index]['cropType'],
                                              style: TextStyle(
                                                fontSize: size.height * 0.02,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Padding(
                          //     padding:
                          //         const EdgeInsets.symmetric(horizontal: 20.0),
                          //     child: Wrap(
                          //       spacing: 8.0,
                          //       runSpacing: 4.0,
                          //       children: crops.map((crop) {
                          //         return Chip(
                          //           labelStyle: TextStyle(
                          //               fontSize: 15,
                          //               fontWeight: FontWeight.w500),
                          //           color: WidgetStateProperty.all(
                          //               Color.fromRGBO(86, 232, 137, 1)),
                          //           label: Text(crop),
                          //         );
                          //       }).toList(),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                'Requirements',
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
                            child: Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: List<Widget>.generate(
                                    requirements.length, (index) {
                                  return Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Card(
                                      color: requirements[index]['isAccepted']
                                          ? Color.fromARGB(121, 255, 235, 50)
                                          : requirements[index]['isExpired']
                                              ? Color.fromARGB(68, 244, 67, 50)
                                              : const Color.fromARGB(
                                                  92, 76, 175, 50),
                                      elevation: 0,
                                      margin:
                                          EdgeInsets.only(left: 0, right: 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              requirements[index]['isAccepted']
                                                  ? 'Accepted'
                                                  : requirements[index]
                                                          ['isExpired']
                                                      ? 'Expired'
                                                      : 'Available',
                                              style: TextStyle(
                                                color: requirements[index]
                                                        ['isAccepted']
                                                    ? Colors.amber[700]
                                                    : requirements[index]
                                                            ['isExpired']
                                                        ? Colors.red
                                                        : const Color.fromARGB(
                                                            255, 70, 170, 74),
                                                fontSize: size.height * 0.015,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              requirements[index]['cropType'],
                                              style: TextStyle(
                                                fontSize: size.height * 0.02,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 7.5,
                                            // ),
                                            // Align(
                                            //   alignment: Alignment.bottomRight,
                                            //   child: Row(
                                            //     mainAxisAlignment:
                                            //         MainAxisAlignment.end,
                                            //     children: [
                                            //       Container(
                                            //           decoration: BoxDecoration(
                                            //               color: Colors.white,
                                            //               borderRadius:
                                            //                   BorderRadius
                                            //                       .circular(
                                            //                           10)),
                                            //           child: IconButton(
                                            //             icon: Icon(
                                            //               Icons.delete,
                                            //             ),
                                            //             onPressed: () {},
                                            //           )),
                                            //       SizedBox(width: 5),
                                            //       Container(
                                            //           decoration: BoxDecoration(
                                            //               color: Colors.white,
                                            //               borderRadius:
                                            //                   BorderRadius
                                            //                       .circular(
                                            //                           10)),
                                            //           child: IconButton(
                                            //             icon: Icon(
                                            //               Icons.edit,
                                            //             ),
                                            //             onPressed: () {},
                                            //           )),
                                            //     ],
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileEditScreen()));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
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
                            onPressed: logout,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kColor3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
