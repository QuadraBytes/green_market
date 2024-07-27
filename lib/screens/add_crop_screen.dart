import 'package:flutter/material.dart';
import 'package:green_market/components/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:green_market/models/models.dart';

class AddCropScreen extends StatefulWidget {
  const AddCropScreen({super.key});

  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _farmerName;
  String? _district;
  String? _address;
  String? _phoneNumber;
  String? _cultivatedArea;
  String? _farmerType;
  int? _weight;
  DateTime? _availableDate;
  DateTime? _expiringDate;
  int? _price;
  File? _image;

  final ImagePicker _picker = ImagePicker();

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
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Crop"),
        backgroundColor: kColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Farmer Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter farmer name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _farmerName = value;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'District'),
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
                validator: (value) {
                  if (value == null) {
                    return 'Please select a district';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value;
                },
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Weight'),
                items: weightRange.map((int weight) {
                  return DropdownMenuItem<int>(
                    value: weight,
                    child: Text('$weight kg'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _weight = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a weight';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(
                    "Available Date: ${_availableDate?.toLocal().toIso8601String().substring(0, 10) ?? 'Not selected'}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                title: Text(
                    "Expiring Date: ${_expiringDate?.toLocal().toIso8601String().substring(0, 10) ?? 'Not selected'}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Price'),
                items: priceRange.map((int price) {
                  return DropdownMenuItem<int>(
                    value: price,
                    child: Text('Rs. $price'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _price = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a price';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cultivated Area'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cultivated area';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cultivatedArea = value;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: const Text('Single'),
                      leading: Radio<String>(
                        value: 'Single',
                        groupValue: _farmerType,
                        onChanged: (String? value) {
                          setState(() {
                            _farmerType = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Farmer Group'),
                      leading: Radio<String>(
                        value: 'Farmer Group',
                        groupValue: _farmerType,
                        onChanged: (String? value) {
                          setState(() {
                            _farmerType = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _image == null ? Text('No image selected.') : Image.file(_image!),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Upload Photo'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cancel button action
                    },
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 168, 165, 165)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Submit button action
                        // Handle form submission here
                      }
                    },
                    child: Text('Submit'),
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
    );
  }
}
