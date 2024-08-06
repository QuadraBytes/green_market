import 'package:flutter/material.dart';
import 'package:green_market/components/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  int _currentIndex = 0;

  void _showCropDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Stack(children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    image: DecorationImage(
                      image: AssetImage("assets/images/crop.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Crop Name',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Farmer Name',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF222325),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'District',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF072471),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Weight',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF222325),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF222325),
                        ),
                      ),
                      // SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          onPressed: () {},
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                          backgroundColor: kColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
                right: 15,
                top: 15,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      size: 30,
                      Icons.close,
                      color: Colors.white,
                    ))),
          ]),
        );
      },
    );
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
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: 25,
              left: size.width * 0.35,
              right: size.width * 0.3,
              child: Text('Favourites',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              bottom: 56,
              child: _currentIndex == 0
                  ? Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: GestureDetector(
                            onTap: _showCropDetails,
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              color: kColor2,
                              child: Container(
                                height: size.height * 0.20,
                                padding: EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image(
                                                width: size.width * 0.3,
                                                height: size.height * 0.125,
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    "assets/images/crop.jpg"),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Crop Name',
                                              style: TextStyle(
                                                  color: Color(0xFF222325),
                                                  fontSize:
                                                      size.height * 0.0175,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Farmer Name',
                                                  style: TextStyle(
                                                    color: Color(0xFF222325),
                                                    fontSize:
                                                        size.height * 0.0175,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  'District',
                                                  style: TextStyle(
                                                      color: Color(0xFF072471),
                                                      fontSize:
                                                          size.height * 0.015,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  'Weight',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          size.height * 0.015,
                                                      color: Color(0xFF222325)),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  'Price',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          size.height * 0.015,
                                                      color: Color(0xFF222325)),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              color: kColor,
                                                              child: IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon: Icon(
                                                                  size: 17,
                                                                  Icons
                                                                      .chat_bubble,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              color: kColor,
                                                              child: IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon: Icon(
                                                                  size: 17,
                                                                  Icons.call,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              color: kColor,
                                                              child: IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon: Icon(
                                                                  size: 17,
                                                                  Icons
                                                                      .favorite,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: kColor2,
                            child: Container(
                              height: size.height * 0.23,
                              padding: EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Crop Name',
                                              style: TextStyle(
                                                  color: Color(0xFF222325),
                                                  fontSize:
                                                      size.height * 0.0175,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              'Buyer Name',
                                              style: TextStyle(
                                                color: Color(0xFF222325),
                                                fontSize: size.height * 0.0175,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              'District',
                                              style: TextStyle(
                                                  color: Color(0xFF072471),
                                                  fontSize: size.height * 0.015,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              'Required Weight',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: size.height * 0.015,
                                                  color: Color(0xFF222325)),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              'Required Date',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: size.height * 0.015,
                                                  color: Color(0xFF222325)),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    padding: EdgeInsets.zero,
                                                    color: kColor,
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        size: 17,
                                                        Icons.chat_bubble,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    padding: EdgeInsets.zero,
                                                    color: kColor,
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        size: 17,
                                                        Icons.call,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    padding: EdgeInsets.zero,
                                                    color: kColor,
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        size: 17,
                                                        Icons.favorite,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: kColor,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Icon(
                      Icons.local_florist,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(height: 2),
                    Text('Crops', style: TextStyle(color: Colors.white)),
                  ],
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Icon(
                        Icons.assignment,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(height: 2),
                      Text('Requirements',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
