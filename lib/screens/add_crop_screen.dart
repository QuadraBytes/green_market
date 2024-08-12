import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_market/components/bottom_bar.dart';
import 'package:green_market/components/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:green_market/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

late User? loggedInUser;

class AddCropScreen extends StatefulWidget {
  const AddCropScreen({super.key});

  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  // Existing variables
  final _formKey = GlobalKey<FormState>();
  String? _farmerName;
  String? _district;
  String? _address;
  String? _phoneNumber;
  String? _cultivatedArea;
  String? _cropType;
  String? _farmerType;
  String? _weight;
  DateTime? _availableDate;
  DateTime? _expiringDate;
  String? _price;
  List<File> _images = [];
  final _auth = FirebaseAuth.instance;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  final CollectionReference cropsCollection =
      FirebaseFirestore.instance.collection('crops');

  Future<void> getUserData() async {
    loggedInUser = await _auth.currentUser!;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(loggedInUser?.email)
        .get();

    setState(() {
      _farmerName = userSnapshot['displayName'].toString();
    });
  }

  Future<void> _selectDate(BuildContext context, bool isAvailableDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        if (isAvailableDate) {
          _availableDate = picked;
        } else {
          _expiringDate = picked;
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_district == null ||
          _address == null ||
          _phoneNumber == null ||
          _availableDate == null ||
          _expiringDate == null ||
          _cultivatedArea == null ||
          _cropType == null ||
          _weight == null ||
          _farmerType == null ||
          _price == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please fill all fields'),
            backgroundColor: Colors.red));
        return;
      }

      try {
        await cropsCollection.add({
          'userId': loggedInUser?.uid,
          'farmerName': _farmerName,
          'district': _district,
          'address': _address,
          'phoneNumber': _phoneNumber,
          'cultivatedArea': _cultivatedArea,
          'cropType': _cropType,
          'farmerType': _farmerType,
          'weight': _weight,
          'availableDate': _availableDate,
          'expiringDate': _expiringDate,
          'price': _price,
          // 'images': _images.map((image) => image.path).toList(),
        });

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const BottomBarScreen();
        }));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to add crop: $error'),
            backgroundColor: Colors.red));
      }
    }
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
                    Text('Add Crop',
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
                    //   decoration: InputDecoration(labelText: "Farmer's Name"),
                    //   onSaved: (value) {
                    //     _farmerName = value;
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
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      style: TextStyle(fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          labelText: 'Address',
                          hintText: 'Eg: No, Street, City',
                          hintStyle: TextStyle(
                              color: const Color.fromRGBO(158, 158, 158, 1),
                              fontWeight: FontWeight.normal),
                          suffixIcon: Icon(
                            Icons.location_on,
                            size: 20,
                          )),
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
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration:
                                InputDecoration(labelText: 'Single/Group'),
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 25,
                              ),
                            ),
                            items: groupType.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child:
                                    Text(type, style: TextStyle(fontSize: 16)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _farmerType = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(context, true),
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Available Date',
                                    suffixIcon: Icon(Icons.calendar_today)),
                                controller: TextEditingController(
                                  text: _availableDate == null
                                      ? ''
                                      : _availableDate
                                          ?.toLocal()
                                          .toIso8601String()
                                          .substring(0, 10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(context, false),
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Expire Date',
                                    suffixIcon: Icon(Icons.calendar_today)),
                                controller: TextEditingController(
                                    text: _expiringDate == null
                                        ? ''
                                        : _expiringDate
                                            ?.toLocal()
                                            .toIso8601String()
                                            .substring(0, 10)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            menuMaxHeight:
                                MediaQuery.of(context).size.height * 0.3,
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 25,
                              ),
                            ),
                            decoration: InputDecoration(labelText: 'Price'),
                            items: priceRange.map((String price) {
                              return DropdownMenuItem<String>(
                                value: price,
                                child: Text('Rs. $price'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _price = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Cultivated Area', suffixText: 'ha'),
                            style: TextStyle(fontWeight: FontWeight.w500),
                            onSaved: (value) {
                              _cultivatedArea = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: _images.length == 2 ? null : _pickImage,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: _images.length == 0
                                  ? 'Upload Images (2)'
                                  : _images.length == 1
                                      ? 'One Image is Uploaded'
                                      : 'Two Images are Uploaded',
                              suffixIcon: Icon(Icons.add_a_photo)),
                          style: TextStyle(fontWeight: FontWeight.w500),
                          // validator: (_) {
                          //   if (_images.isEmpty) {
                          //     return 'Please add an image';
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      children: _images.asMap().entries.map((entry) {
                        int index = entry.key;
                        File imageFile = entry.value;
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Image.file(imageFile,
                                width: 150, height: 150, fit: BoxFit.contain),
                            IconButton(
                              icon: Icon(Icons.cancel, color: kColor),
                              onPressed: () => _removeImage(index),
                            ),
                          ],
                        );
                      }).toList(),
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
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 168, 165, 165)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
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
