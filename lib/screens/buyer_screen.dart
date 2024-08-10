import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'package:green_market/components/buyer_screen_card.dart';
import 'package:green_market/components/constants.dart';
import 'package:green_market/screens/add_requirement_screen.dart';
import 'package:green_market/screens/favourites_screen.dart';
import 'package:green_market/screens/profile_screen.dart';
import 'package:intl/intl.dart';

class BuyerScreen extends StatefulWidget {
  const BuyerScreen({super.key});

  @override
  State<BuyerScreen> createState() => _BuyerScreenState();
}

class _BuyerScreenState extends State<BuyerScreen> {
  bool showSearchBar = false;
  bool isDistrictExpanded = false;
  bool isWeightExpanded = false;
  bool isPriceExpanded = false;
  bool isAvailableSelected = false;
  bool isUpcomingSelected = false;
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus) {
        setState(() {
          showSearchBar = false;
        });
      }
    });
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    super.dispose();
  }

  void _showFilterSheet(BuildContext context) {
    // Existing filter sheet code...
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        floatingActionButton: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRequirementScreen()),
              );
            },
            child: Icon(
              Icons.add,
              size: 35,
              color: Colors.white,
            ),
            backgroundColor: kColor,
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: !showSearchBar ? 65 : 75,
          title: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  !showSearchBar
                      ? IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.list,
                            color: Colors.black,
                            size: 35,
                          ),
                        )
                      : Container(),
                  !showSearchBar ? SizedBox(width: 10) : Container(),
                  Expanded(
                    child: !showSearchBar
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  searchFocusNode.requestFocus();
                                  showSearchBar = !showSearchBar;
                                });
                              },
                              icon: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 27.5,
                              ),
                            ),
                          )
                        : TextField(
                            focusNode: searchFocusNode,
                            decoration: InputDecoration(
                              fillColor: const Color.fromRGBO(0, 0, 0, 0),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.mic_outlined,
                                ),
                              ),
                              hintText: 'Search Crop',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide:
                                    BorderSide(width: 2, color: Colors.black),
                              ),
                              filled: true,
                            ),
                            style: TextStyle(fontSize: 15.0),
                          ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.filter_alt_outlined,
                      size: 30,
                    ),
                    onPressed: () {
                      _showFilterSheet(context);
                    },
                  ),
                  !showSearchBar
                      ? IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavouritesScreen()),
                            );
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.black,
                            size: 30,
                          ),
                        )
                      : Container(),
                  !showSearchBar
                      ? IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen()),
                            );
                          },
                          icon: Icon(
                            Icons.person,
                            color: Colors.black,
                            size: 30,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            searchFocusNode.unfocus();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('crops').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final data = snapshot.requireData;

                return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    var crop = data.docs[index];
                    DateTime expiringDate =
                        (crop['expiringDate'] as Timestamp).toDate();

                    // Format DateTime to a String
                    String formattedExpDate =
                        DateFormat('yyyy-MM-dd').format(expiringDate);
                    return BuyerScreenCard(
                      farmerName: crop['farmerName'],
                      cropType: crop['cropType'],
                      district: crop['district'],
                      weight: crop['weight'],
                      expiringDate: formattedExpDate,
                      price: crop['price'],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
