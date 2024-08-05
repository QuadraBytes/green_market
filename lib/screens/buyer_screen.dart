import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:green_market/components/constants.dart';
import 'package:green_market/models/models.dart';
import 'package:green_market/screens/add_requirement_screen.dart';
import 'package:green_market/screens/favourites_screen.dart';
import 'package:green_market/screens/profile_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late Stream<QuerySnapshot> _requireStream;

  @override
  void initState() {
    super.initState();
    _requireStream =
        FirebaseFirestore.instance.collection('requirements').snapshots();
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
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Stack(children: [
              Positioned(
                top: 10,
                left: size.width * 0.35,
                right: size.width * 0.35,
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  width: size.width * 0.3,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromARGB(255, 0, 110, 57),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 60),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isAvailableSelected) {
                                      isAvailableSelected = false;
                                    } else {
                                      isAvailableSelected = true;
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: isAvailableSelected == false
                                          ? Border.all(
                                              width: 1,
                                              style: BorderStyle.solid,
                                              color: Color.fromARGB(
                                                  255, 0, 110, 57))
                                          : Border.all(
                                              color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(50),
                                      color: isAvailableSelected
                                          ? Color.fromARGB(255, 0, 110, 57)
                                          : Colors.transparent),
                                  child: Text(
                                    'Available',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: isAvailableSelected
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isUpcomingSelected) {
                                    isUpcomingSelected = false;
                                  } else {
                                    isUpcomingSelected = true;
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: isUpcomingSelected == false
                                        ? Border.all(
                                            width: 1,
                                            style: BorderStyle.solid,
                                            color:
                                                Color.fromARGB(255, 0, 110, 57))
                                        : Border.all(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(50),
                                    color: isUpcomingSelected
                                        ? Color.fromARGB(255, 0, 110, 57)
                                        : Colors.transparent),
                                child: Text(
                                  'Upcoming',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isUpcomingSelected
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: ExpansionPanelList(
                          dividerColor: const Color.fromARGB(255, 0, 110, 57),
                          elevation: 0,
                          expandIconColor:
                              const Color.fromARGB(255, 0, 110, 57),
                          materialGapSize: 0,
                          expandedHeaderPadding: EdgeInsets.zero,
                          children: [
                            ExpansionPanel(
                              backgroundColor: Colors.transparent,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(
                                    'District',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                );
                              },
                              body: Column(
                                children: [
                                  Column(
                                    children: districts
                                        .map((district) => ListTile(
                                              title: Text(district),
                                              onTap: () {},
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                              isExpanded: isDistrictExpanded,
                              canTapOnHeader: true,
                            ),
                            ExpansionPanel(
                              backgroundColor: Colors.transparent,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Weight',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              body: Column(
                                children: List.generate(
                                  weightRange.length,
                                  (index) => ListTile(
                                    title: Text(index == 0
                                        ? 'Below ${weightRange[index]} kg'
                                        : index == weightRange.length - 1
                                            ? 'Above ${weightRange[index]} kg'
                                            : '${weightRange[index]} - ${weightRange[index + 1]} kg'),
                                    onTap: () {},
                                  ),
                                ),
                              ),
                              isExpanded: isWeightExpanded,
                              canTapOnHeader: true,
                            ),
                            ExpansionPanel(
                              backgroundColor: Colors.transparent,
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(
                                    'Price',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                );
                              },
                              body: Column(
                                children: List.generate(
                                  priceRange.length,
                                  (index) => ListTile(
                                    title: Text(index == 0
                                        ? 'Below Rs.${priceRange[index]}'
                                        : index == priceRange.length - 1
                                            ? 'Above Rs.${priceRange[index]}'
                                            : 'Rs.${priceRange[index]} - ${priceRange[index + 1]}'),
                                    onTap: () {},
                                  ),
                                ),
                              ),
                              isExpanded: isPriceExpanded,
                              canTapOnHeader: true,
                            ),
                          ],
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              if (index == 0) {
                                isDistrictExpanded = !isDistrictExpanded;
                                if (isDistrictExpanded) {
                                  isWeightExpanded = false;
                                  isPriceExpanded = false;
                                }
                              } else if (index == 1) {
                                isWeightExpanded = !isWeightExpanded;
                                if (isWeightExpanded) {
                                  isDistrictExpanded = false;
                                  isPriceExpanded = false;
                                }
                              } else if (index == 2) {
                                isPriceExpanded = !isPriceExpanded;
                                if (isPriceExpanded) {
                                  isDistrictExpanded = false;
                                  isWeightExpanded = false;
                                }
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
            ]);
          },
        );
      },
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(dateTime);
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
        body: StreamBuilder(
            stream: _requireStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('No requirements found'),
                );
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  Timestamp timestamp = data['requiredDate'];
                  String formattedDate = _formatTimestamp(timestamp);

                  return GestureDetector(
                    onTap: () {
                      searchFocusNode.unfocus();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: kColor2,
                        child: Container(
                          height: size.height * 0.15,
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: size.width * 0.8,
                                          child: Row(
                                            children: [
                                              Text(
                                                data['cropType'],
                                                style: TextStyle(
                                                    color: Color(0xFF222325),
                                                    fontSize:
                                                        size.height * 0.0175,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Colors.red,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    data['district'],
                                                    style: TextStyle(
                                                        color: kColor4,
                                                        fontSize:
                                                            size.height * 0.015,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              color: Colors.black,
                                              size: 17.5,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              data['buyerName'],
                                              style: TextStyle(
                                                color: Color(0xFF222325),
                                                fontSize: size.height * 0.0175,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width: size.width * 0.8,
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Weight :',
                                                        style: TextStyle(
                                                            color: kColor4,
                                                            fontSize:
                                                                size.height *
                                                                    0.015,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        '${data['weight']} kg',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize:
                                                                size.height *
                                                                    0.015,
                                                            color: Color(
                                                                0xFF222325)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Required Date :',
                                                        style: TextStyle(
                                                            color: kColor4,
                                                            fontSize:
                                                                size.height *
                                                                    0.015,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        formattedDate,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize:
                                                                size.height *
                                                                    0.015,
                                                            color: Color(
                                                                0xFF222325)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              // ClipRRect(
                                              //   borderRadius:
                                              //       BorderRadius.circular(10),
                                              //   child: Container(
                                              //     padding: EdgeInsets.zero,
                                              //     color: kColor,
                                              //     child: IconButton(
                                              //       onPressed: () {},
                                              //       icon: Icon(
                                              //         size: 17,
                                              //         Icons.chat_bubble,
                                              //         color: Colors.white,
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              // Spacer(),
                                              // SizedBox(
                                              //   width: 10,
                                              // ),
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
                                          ),
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
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}
