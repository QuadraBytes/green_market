import 'package:flutter/material.dart';
import 'package:green_market/components/constants.dart';
import 'package:green_market/components/side_bar.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        drawer: SideBar(),
        body: Stack(
          children: [
            Positioned(
                top: -40, child: Image.asset('assets/images/appbar2.png')),
            Positioned(
              top: 15,
              left: 10,
              child: Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(
                      Icons.list,
                      color: Colors.white,
                      size: 35,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
            Positioned(
              top: 25,
              left: size.width * 0.35,
              right: size.width * 0.3,
              child: Text('Availability',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ),
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Column(
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
                        height: size.height * 0.105,
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Crop Name',
                                  style: TextStyle(
                                      color: Color(0xFF222325),
                                      fontSize: size.height * 0.0175,
                                      fontWeight: FontWeight.w700),
                                ),
                                Spacer(),
                                Container(
                                  child: Text(
                                    'Total Weight',
                                    style: TextStyle(
                                      color: Color(0xFF222325),
                                      fontSize: size.height * 0.0175,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  child: Text(
                                    'Kandy, Anuradhapura, Nuwara Eliya',
                                    style: TextStyle(
                                      color: Color(0xFF222325),
                                      fontSize: size.height * 0.0175,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
