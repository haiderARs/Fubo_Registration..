import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StallRegistrationScreen extends StatefulWidget {
  @override
  _StallRegistrationScreenState createState() =>
      _StallRegistrationScreenState();
}

class _StallRegistrationScreenState extends State<StallRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController takerNameController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  String _selectedStallType = 'Food Stall';
  double generatedPrice = 0.0;

  final Map<String, double> _stallTypes = {
    'Food Stall': 2000.0,
    'Clothing Stall': 1500.0,
    'Tech Gadget Stall': 2500.0,
    'Handicraft Stall': 1800.0,
  };

  void _updatePrice(String selectedStallType) {
    setState(() {
      generatedPrice = _stallTypes[selectedStallType] ?? 0.0;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showPaymentModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            bool isPaymentButtonEnabled =
                cardNumberController.text.length == 16 && pinController.text.length == 4;

            void _updatePaymentButtonState() {
              setModalState(() {
                isPaymentButtonEnabled =
                    cardNumberController.text.length == 16 && pinController.text.length == 4;
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: cardNumberController,
                    decoration: InputDecoration(labelText: 'Debit Card Number'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                    ],
                    onChanged: (value) => _updatePaymentButtonState(),
                  ),
                  TextField(
                    controller: pinController,
                    decoration: InputDecoration(labelText: 'PIN'),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    onChanged: (value) => _updatePaymentButtonState(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isPaymentButtonEnabled
                        ? () {
                      Navigator.pop(context);
                      _confirmRegistration();
                    }
                        : null,
                    child: Text(
                      'Payment Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isPaymentButtonEnabled ? Colors.orange : Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmRegistration() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registration Confirmed. Stall Booked!'),
        backgroundColor: Colors.green,
      ),
    );
    _submitForm();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Prepare data to be saved to Firebase
      final stallData = {
        'takerName': takerNameController.text,
        'cnic': cnicController.text,
        'dateOfRegistration': dateController.text,
        'contactNumber': contactNumberController.text,
        'stallType': _selectedStallType,
        'price': generatedPrice,
      };

      // Save data to Firestore in 'StallRegistration' collection
      try {
        await FirebaseFirestore.instance
            .collection('StallRegistration')
            .add(stallData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Stall Registration Successful')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }

      // Close the screen after successful submission
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Stall Registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stall Name Field
              TextFormField(
                controller: takerNameController,
                decoration: InputDecoration(labelText: 'Taker Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), // Only allows letters and spaces
                ],
              ),

              TextFormField(
                controller: cnicController,
                decoration: InputDecoration(labelText: 'CNIC'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CNIC';
                  } else if (!RegExp(r'^\d{5}\d{7}\d{1}$').hasMatch(value)) {
                    return 'Invalid CNIC format';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  LengthLimitingTextInputFormatter(13),  // Limit input to 13 digits
                ],
              ),
              // Date of Registration Field
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date of Registration',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, color: Colors.orange),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: contactNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  } else if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                    return 'Invalid phone number';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
              ),
              // Stall Type Selection and Price Display
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Stall Type'),
                value: _selectedStallType,
                items: _stallTypes.keys
                    .map((stallType) => DropdownMenuItem<String>(
                  value: stallType,
                  child: Text(stallType),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStallType = value!;
                    _updatePrice(value);
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a stall type';
                  }
                  return null;
                },
              ),

              // Display Generated Price
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Generated Price: Rs. $generatedPrice',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _showPaymentModal();
                  }
                },
                child: Text('Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
