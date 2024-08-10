import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_market/components/buyer_screen_card.dart';
import 'package:green_market/components/constants.dart';
import 'package:green_market/models/models.dart';
import 'package:green_market/screens/add_requirement_screen.dart';
import 'package:green_market/screens/favourites_screen.dart';
import 'package:green_market/screens/profile_screen.dart';
import 'package:intl/intl.dart';

late User? loggedInUser;

class BuyerScreen extends StatefulWidget {
  const BuyerScreen({super.key});

  @override
  State<BuyerScreen> createState() => _BuyerScreenState();
}

class _BuyerScreenState extends State<BuyerScreen> {
  TextEditingController searchText = TextEditingController();
  String selectedDistrict = '';
  List<String> selectedWeightRange = [];
  List<String> selectedPriceRange = [];
  bool isAvailableSelected = false;
  bool isUpcomingSelected = false;

  bool showSearchBar = false;
  bool isDistrictExpanded = false;
  bool isWeightExpanded = false;
  FocusNode searchFocusNode = FocusNode();
  late List requireList = [];
  late List searchList = [];
  late List filterList = [];
  late List unionRequireList = [];
  List<String> requireFavourites = [];

  final _auth = FirebaseAuth.instance;

  void getCurrentUser() async {
    final user = await _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      await getUserFavourites();
    }
  }

  Future<void> getUserFavourites() async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUser!.email)
          .get();

      if (userDoc.exists) {
        setState(() {
          requireFavourites =
              List<String>.from(userDoc['requireFavourites'] ?? []);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getAllCrops();
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

  getAllCrops() async {
    var list =
        await FirebaseFirestore.instance.collection('requirements').get();
    setState(() {
      requireList = list.docs;
      searchList = requireList;
      unionRequireList = requireList;
    });
  }

  addFavourites(String cropId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUser!.email)
          .update({
        'requireFavourites': FieldValue.arrayUnion([cropId]),
      });

      setState(() {
        requireFavourites.add(cropId);
      });
    } catch (e) {
      print(e);
    }
  }

  removeFavourites(String cropId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUser!.email)
          .update({
        'requireFavourites': FieldValue.arrayRemove([cropId]),
      });

      setState(() {
        requireFavourites.remove(cropId);
      });
    } catch (e) {
      print(e);
    }
  }

  bool isFavourite(String cropId) {
    return requireFavourites.contains(cropId);
  }

  updateUnionList() {
    setState(() {
      if (searchText.text.isEmpty &&
          selectedDistrict.isEmpty &&
          selectedWeightRange.isEmpty) {
        unionRequireList = requireList;
      } else if (searchText.text.isNotEmpty && selectedDistrict.isNotEmpty ||
          selectedWeightRange.isNotEmpty) {
        unionRequireList =
            searchList.toSet().intersection(filterList.toSet()).toList();
      } else if (searchText.text.isEmpty && selectedDistrict.isNotEmpty ||
          selectedWeightRange.isNotEmpty) {
        unionRequireList = filterList;
      } else if (searchText.text.isNotEmpty &&
          selectedDistrict.isEmpty &&
          selectedWeightRange.isEmpty) {
        unionRequireList = searchList;
      }
    });
  }

  searchFilter() {
    if (searchText.text.isNotEmpty) {
      String searchLower = searchText.text.toLowerCase();
      List list = [];
      for (var crop in requireList) {
        if (crop['cropType'].toString().toLowerCase().contains(searchLower) ||
            crop['buyerName'].toString().toLowerCase().contains(searchLower) ||
            searchLower.contains(crop['cropType'].toString().toLowerCase()) ||
            searchLower.contains(crop['buyerName'].toString().toLowerCase())) {
          list.add(crop);
        }
      }
      setState(() {
        searchList = list;
      });
    } else {
      searchList = [];
    }
    updateUnionList();
  }

  Filter() {
    List list = [];
    for (var crop in requireList) {
      bool isInclude = true;

      if (selectedWeightRange.isNotEmpty) {
        int cropWeight = int.parse(crop['weight']);
        if (cropWeight < int.parse(selectedWeightRange[0]) ||
            cropWeight > int.parse(selectedWeightRange[1])) {
          isInclude = false;
        }
      }
      if (selectedDistrict.isNotEmpty && crop['district'] != selectedDistrict) {
        isInclude = false;
      }

      Timestamp requiredDateTimestamp = crop['requiredDate'];
      DateTime requiredDate = requiredDateTimestamp.toDate();

      if (isAvailableSelected) {
        if (requiredDate.isAfter(DateTime.now())) {
          isInclude = false;
        }
      }
      if (isUpcomingSelected) {
        if (requiredDate.isBefore(DateTime.now())) {
          isInclude = false;
        }
      }
      if (isInclude) {
        list.add(crop);
      }
    }
    setState(() {
      filterList = list;
    });
    updateUnionList();
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(dateTime);
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
                                    Filter();
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
                                  Filter();
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
                                              title: selectedDistrict ==
                                                      district
                                                  ? Row(
                                                      children: [
                                                        Icon(
                                                          Icons.check,
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 0, 110, 57),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(district)
                                                      ],
                                                    )
                                                  : Text(district),
                                              onTap: () {
                                                if (selectedDistrict ==
                                                    district) {
                                                  selectedDistrict = '';
                                                } else {
                                                  selectedDistrict = district;
                                                }
                                                Navigator.pop(context);
                                                _showFilterSheet(context);
                                                Filter();
                                              },
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
                                    title: index == 0
                                        ? selectedWeightRange.contains('0') &&
                                                selectedWeightRange.contains(
                                                    weightRange[index])
                                            ? Row(
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: const Color.fromARGB(
                                                        255, 0, 110, 57),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                      'Below ${weightRange[index]} kg'),
                                                ],
                                              )
                                            : Text(
                                                'Below ${weightRange[index]} kg')
                                        : index == weightRange.length - 1
                                            ? selectedWeightRange.contains(
                                                        weightRange[index]) &&
                                                    selectedWeightRange
                                                        .contains('1000')
                                                ? Row(
                                                    children: [
                                                      Icon(
                                                        Icons.check,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 0, 110, 57),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          'Above ${weightRange[index]} kg'),
                                                    ],
                                                  )
                                                : Text(
                                                    'Above ${weightRange[index]} kg')
                                            : selectedWeightRange.contains(
                                                        weightRange[index]) &&
                                                    selectedWeightRange
                                                        .contains(weightRange[
                                                            index + 1])
                                                ? Row(
                                                    children: [
                                                      Icon(
                                                        Icons.check,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 0, 110, 57),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          '${weightRange[index]} - ${weightRange[index + 1]} kg'),
                                                    ],
                                                  )
                                                : Text(
                                                    '${weightRange[index]} - ${weightRange[index + 1]} kg'),
                                    onTap: () {
                                      if (index == 0) {
                                        if (selectedWeightRange.contains('0') &&
                                            selectedWeightRange
                                                .contains(weightRange[index])) {
                                          selectedWeightRange = [];
                                        } else {
                                          selectedWeightRange = [
                                            '0',
                                            weightRange[index]
                                          ];
                                        }
                                      } else if (index ==
                                          weightRange.length - 1) {
                                        if (selectedWeightRange
                                                .contains(weightRange[index]) &&
                                            selectedWeightRange
                                                .contains('1000')) {
                                          selectedWeightRange = [];
                                        } else {
                                          selectedWeightRange = [
                                            weightRange[index],
                                            '1000'
                                          ];
                                        }
                                      } else {
                                        if (selectedWeightRange
                                                .contains(weightRange[index]) &&
                                            selectedWeightRange.contains(
                                                weightRange[index + 1])) {
                                          selectedWeightRange = [];
                                        } else {
                                          selectedWeightRange = [
                                            weightRange[index],
                                            weightRange[index + 1]
                                          ];
                                        }
                                      }
                                      print(selectedWeightRange);
                                      Navigator.pop(context);
                                      _showFilterSheet(context);
                                      Filter();
                                    },
                                  ),
                                ),
                              ),
                              isExpanded: isWeightExpanded,
                              canTapOnHeader: true,
                            ),
                          ],
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              if (index == 0) {
                                isDistrictExpanded = !isDistrictExpanded;
                                if (isDistrictExpanded) {
                                  isWeightExpanded = false;
                                }
                              } else if (index == 1) {
                                isWeightExpanded = !isWeightExpanded;
                                if (isWeightExpanded) {
                                  isDistrictExpanded = false;
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
          toolbarHeight:
              (selectedDistrict != '' || selectedWeightRange.isNotEmpty)
                  ? showSearchBar
                      ? 110
                      : 100
                  : showSearchBar
                      ? 70
                      : 60,
          title: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                                controller: searchText,
                                onChanged: (text) {
                                  searchFilter();
                                },
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
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.black),
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
                  !showSearchBar
                      ? Container()
                      : SizedBox(
                          height: 10,
                        ),
                  if (selectedDistrict.isNotEmpty ||
                      selectedWeightRange.isNotEmpty)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Wrap(
                              spacing: 8.0,
                              children: [
                                if (selectedDistrict.isNotEmpty)
                                  Chip(
                                    label: Text(selectedDistrict),
                                    onDeleted: () {
                                      setState(() {
                                        selectedDistrict = '';
                                        Filter();
                                      });
                                    },
                                  ),
                                if (selectedWeightRange.isNotEmpty)
                                  Chip(
                                    label: Text(
                                        '${selectedWeightRange.first} - ${selectedWeightRange.last} kg'),
                                    onDeleted: () {
                                      setState(() {
                                        selectedWeightRange = [];
                                        Filter();
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            searchFocusNode.unfocus();
          },
          child: requireList.isEmpty
              ? Center(

                  child: CircularProgressIndicator(
                    color: kColor,
                  ),
                )

              : unionRequireList.isEmpty
                  ? Center(
                      child: Text(
                        'No Requirements Available',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: GestureDetector(
                          // onTap: _showCropDetails,
                          child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('crops')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Something went wrong'));
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            final data = snapshot.requireData;

                            return ListView.builder(
                              itemCount: data.size,
                              itemBuilder: (context, index) {
                                var crop = data.docs[index];
                                DateTime expiringDate =
                                    (crop['expiringDate'] as Timestamp)
                                        .toDate();

                                String formattedReqDate =
                                    DateFormat('yyyy-MM-dd')
                                        .format(expiringDate);
                                return BuyerScreenCard(
                                  farmerName: crop['farmerName'],
                                  cropType: crop['cropType'],
                                  district: crop['district'],
                                  weight: crop['weight'],
                                  expiringDate: formattedReqDate,
                                  price: crop['price'],
                                );
                              },
                            );
                          },
                        ),
                      )),

                    ),
        ),
      ),
    );
  }
}
