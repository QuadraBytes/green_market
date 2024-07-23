import 'package:flutter/material.dart';
import 'package:green_market/components/constants.dart';

class FarmerScreen extends StatefulWidget {
  const FarmerScreen({super.key});

  @override
  State<FarmerScreen> createState() => _FarmerScreenState();
}

class _FarmerScreenState extends State<FarmerScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(
            Icons.add,
            size: 35,
            color: Colors.white,
          ),
          backgroundColor: kColor,
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 75,
        title: Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.list,
                  color: Colors.black,
                  size: 35,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    suffixIcon: Icon(
                      Icons.mic_outlined,
                    ),
                    hintText: 'Search Crop',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(width: 2, color: Colors.black),
                    ),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                  ),
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              IconButton(
                icon: Icon(
                  Icons.filter_alt_outlined,
                  size: 30,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.person, size: 30),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Color.fromARGB(255, 224, 224, 224),
          child: Container(
            margin: EdgeInsets.all(10.0),
            height: size.height * 0.19,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            //   'http://localhost:3000/' +
                            //       post['UploadImageLink']
                            //           .replaceAll(
                            //               r'\',
                            //               '/')
                            //           .replaceAll(
                            //               'public/',
                            //               ''),
                            width: size.width * 0.3,
                            height: size.height * 0.125,
                            fit: BoxFit.cover,

                            image: AssetImage("assets/images/crop.jpg"),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Crop Name',
                          style: TextStyle(
                              color: Color(0xFF222325),
                              fontSize: size.height * 0.0175,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Farmer Name',
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
                              'Weight',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.height * 0.015,
                                  color: Color(0xFF222325)),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Price',
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
                                  borderRadius: BorderRadius.circular(10),
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
                                  borderRadius: BorderRadius.circular(10),
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
                                  borderRadius: BorderRadius.circular(10),
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
