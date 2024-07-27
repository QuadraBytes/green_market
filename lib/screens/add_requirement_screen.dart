import 'package:flutter/material.dart';
import 'package:green_market/components/constants.dart';
import 'package:green_market/models/models.dart';

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
  String? _cropName;
  int? _weight;
  DateTime? _requiredDate;

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
          _requiredDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Requirement"),
        backgroundColor: kColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Buyers Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter buyer name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _buyerName = value;
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
                    "Required Date: ${_requiredDate?.toLocal().toIso8601String().substring(0, 10) ?? 'Not selected'}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
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
      ), // Your screen content
    );
  }
}
