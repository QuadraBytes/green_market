import 'package:flutter/material.dart';
import 'package:green_market/components/constants.dart';
import 'package:green_market/components/farmer_screen_card.dart';

class BuyerScreenCard extends StatelessWidget {
  final String cropType;
  final String farmerName;
  final String district;
  final String weight;
  final String expiringDate;
  final String price;

  const BuyerScreenCard({
    Key? key,
    required this.cropType,
    required this.farmerName,
    required this.district,
    required this.weight,
    required this.expiringDate,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: kColor2,
      child: Container(
        height: size.height * 0.3,
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Crop Type: $cropType',
                        style: TextStyle(
                          color: Color(0xFF222325),
                          fontSize: size.height * 0.0175,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Farmer Name: $farmerName',
                        style: TextStyle(
                          color: Color(0xFF222325),
                          fontSize: size.height * 0.0175,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'District: $district',
                        style: TextStyle(
                          color: Color(0xFF072471),
                          fontSize: size.height * 0.015,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Weight: $weight Kg',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.height * 0.015,
                          color: Color(0xFF222325),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Price: $price',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.height * 0.015,
                          color: Color(0xFF222325),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Expiring Date: $expiringDate',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.height * 0.015,
                          color: Color(0xFF222325),
                        ),
                      ),
                      SizedBox(height: 10),
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
                          SizedBox(width: 10),
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
                          SizedBox(width: 10),
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
