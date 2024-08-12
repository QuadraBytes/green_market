import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_market/components/bottom_bar.dart';
import 'package:green_market/components/constants.dart';
import 'package:green_market/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

late User? loggedInUser;

class AddRequirementScreen extends StatefulWidget {
  const AddRequirementScreen({super.key});

  @override
  State<AddRequirementScreen> createState() => _AddRequirementScreenState();
}

class _AddRequirementScreenState extends State<AddRequirementScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _buyerName;
  String? _district;
  String? _address;
  String? _phoneNumber;
  String? _cropType;
  String? _weight;
  DateTime? _requiredDate;
  final _auth = FirebaseAuth.instance;

  final CollectionReference requirements =
      FirebaseFirestore.instance.collection('requirements');

  Future<void> getUserData() async {
    loggedInUser = await _auth.currentUser!;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(loggedInUser?.email)
        .get();

    setState(() {
      _buyerName = userSnapshot['displayName'].toString();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _requiredDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_district == null ||
          _address == null ||
          _phoneNumber == null ||
          _requiredDate == null ||
          _cropType == null ||
          _weight == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please fill all fields'),
            backgroundColor: Colors.red));
        return;
      }

      try {
        await requirements.add({
          'userId': loggedInUser!.uid,
          'buyerName': _buyerName,
          'district': _district,
          'address': _address,
          'phoneNumber': _phoneNumber,
          'cropType': _cropType,
          'weight': _weight,
          'requiredDate': _requiredDate,
        });

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return const BottomBarScreen();
        }));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add requirement: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
                top: -50, child: Image.asset('assets/images/appbar2.png')),
            Container(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Text('Add Requirement',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    SizedBox(
                      height: 50,
                    ),
                    // TextFormField(
                    //   style: TextStyle(fontWeight: FontWeight.w500),
                    //   decoration: InputDecoration(labelText: "Buyer's Name"),
                    //   // validator: (value) {
                    //   //   if (value == null || value.isEmpty) {
                    //   //     return "Please enter buyer's name";
                    //   //   }
                    //   //   return null;
                    //   // },
                    //   onSaved: (value) {
                    //     _buyerName = value;
                    //   },
                    // ),
                    // SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
                      decoration: InputDecoration(
                        labelText: 'District',
                        // suffixIcon: Icon(
                        //   Icons.keyboard_arrow_down_outlined,
                        //   size: 30,
                        // ),
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 25,
                        ),
                      ),
                      items: districts.map((String district) {
                        return DropdownMenuItem<String>(
                          value: district,
                          child: Text(district),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _district = value;
                        });
                      },
                      // validator: (value) {
                      //   if (value == null) {
                      //     return 'Please select a district';
                      //   }
                      //   return null;
                      // },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      style: TextStyle(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          labelText: 'Address',
                          hintText: 'Eg: No, Street, City',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          suffixIcon: Icon(
                            Icons.location_on,
                            size: 20,
                          )),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter address';
                      //   }
                      //   return null;
                      // },
                      onSaved: (value) {
                        _address = value;
                      },
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Phone Number',
                                prefixText: '+94 ',
                                prefixStyle:
                                    TextStyle(fontWeight: FontWeight.w500),
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                                hintText: 'XX XXX XXX'),
                            style: TextStyle(fontWeight: FontWeight.w500),
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter phone number';
                            //   }
                            //   return null;
                            // },
                            onSaved: (value) {
                              _phoneNumber = value;
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(labelText: 'Crop Type'),
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 25,
                              ),
                            ),
                            items: weightRange.map((String weight) {
                              return DropdownMenuItem<String>(
                                value: weight,
                                child: Text('$weight kg',
                                    style: TextStyle(fontSize: 16)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _cropType = value;
                              });
                            },
                            // validator: (value) {
                            //   if (value == null) {
                            //     return 'Please select a crop type';
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(labelText: 'Weight'),
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 25,
                              ),
                            ),
                            items: weightRange.map((String weight) {
                              return DropdownMenuItem<String>(
                                value: weight,
                                child: Text('$weight kg',
                                    style: TextStyle(fontSize: 16)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _weight = value;
                              });
                            },
                            // validator: (value) {
                            //   if (value == null) {
                            //     return 'Please select a weight';
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Required Date',
                                    suffixIcon: Icon(Icons.calendar_today)),
                                controller: TextEditingController(
                                    text: _requiredDate == null
                                        ? ''
                                        : _requiredDate
                                            ?.toLocal()
                                            .toIso8601String()
                                            .substring(0, 10)),
                                // validator: (value) {
                                //   if (_requiredDate == null) {
                                //     return 'Please select the required date';
                                //   }
                                //   return null;
                                // },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 168, 165, 165)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _submitForm();
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
                )),
          ],
        ),
      ),
    );
  }
}
