import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore integration
import 'signup_screen.dart';
class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController universityCardNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration Page"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // First Name Field
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), // Only allows letters and spaces
                  ],
                ),

                // Last Name Field
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), // Only allows letters and spaces
                  ],
                ),

                // Phone Number Field
                TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),

                // Age Field
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    } else if (int.tryParse(value) == null) {
                      return 'Please enter a valid age';
                    } else if (int.parse(value) < 15) {
                      return 'You must be at least 15 years old to register';
                    }
                    return null;
                  },
                ),

                // Batch Number Field
                DropdownButtonFormField<String>(
                  value: batchController.text.isEmpty ? null : batchController.text,
                  onChanged: (String? newValue) {
                    batchController.text = newValue ?? '';
                  },
                  decoration: InputDecoration(
                    labelText: 'Batch',
                  ),
                  items: [
                    ...List.generate(11, (index) => 'F-${14 + index}'),
                    ...List.generate(11, (index) => 'SP-${14 + index}')
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your batch';
                    }
                    return null;
                  },
                ),

                // CNIC Field
                TextFormField(
                  controller: cnicController,
                  decoration: InputDecoration(labelText: 'CNIC'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your CNIC';
                    } else if (!RegExp(r'^\d{13}$').hasMatch(value)) {
                      return 'Please enter a valid CNIC';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    LengthLimitingTextInputFormatter(13),  // Limit input to 13 digits
                  ],
                ),

                // Department Field
                DropdownButtonFormField<String>(
                  value: departmentController.text.isEmpty ? null : departmentController.text,
                  onChanged: (String? newValue) {
                    departmentController.text = newValue ?? '';
                  },
                  decoration: InputDecoration(
                    labelText: 'Department',
                  ),
                  items: [
                    'DEPARTMENT OF ENGINEERING TECHNOLOGY',
                    'DEPARTMENT OF SOFTWARE ENGINEERING',
                    'DEPARTMENT OF SOCIAL SCIENCES',
                    'DEPARTMENT OF ARTS & MEDIA',
                    'DEPARTMENT OF PSYCOLOGY'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your department';
                    }
                    return null;
                  },
                ),

                // Email Field
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                // University Card Number Field

                TextFormField(
                  controller: universityCardNumberController,
                  decoration: InputDecoration(
                    labelText: 'University Card Number',
                    hintText: 'e.g., FUI/FURC/F-22/BSET/023',
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your university card number';
                    } else if (!RegExp(r'^[A-Za-z]{3}/[A-Za-z]{4}/F-\d{2}/[A-Za-z]+/\d{3}$').hasMatch(value)) {
                      return 'University card number format is invalid';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // Register Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Perform the check if the email, university card, CNIC, or phone number exists
                      FirebaseFirestore.instance.collection("UsersProfile")
                          .where("email", isEqualTo: emailController.text)
                          .get()
                          .then((querySnapshot) {
                        if (querySnapshot.docs.isNotEmpty) {
                          // Show alert if email already exists
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('This email is already registered!'),
                            backgroundColor: Colors.red,
                          ));
                        } else {
                          // Check for other fields like university card number, CNIC, and phone number
                          FirebaseFirestore.instance.collection("UsersProfile")
                              .where("universityCardNumber", isEqualTo: universityCardNumberController.text)
                              .get()
                              .then((cardSnapshot) {
                            if (cardSnapshot.docs.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('This university card number is already registered!'),
                                backgroundColor: Colors.red,
                              ));
                            } else {
                              // Proceed to check CNIC and phone number
                              FirebaseFirestore.instance.collection("UsersProfile")
                                  .where("cnic", isEqualTo: cnicController.text)
                                  .get()
                                  .then((cnicSnapshot) {
                                if (cnicSnapshot.docs.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('This CNIC is already registered!'),
                                    backgroundColor: Colors.red,
                                  ));
                                } else {
                                  FirebaseFirestore.instance.collection("UsersProfile")
                                      .where("phoneNumber", isEqualTo: phoneNumberController.text)
                                      .get()
                                      .then((phoneSnapshot) {
                                    if (phoneSnapshot.docs.isNotEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text('This phone number is already registered!'),
                                        backgroundColor: Colors.red,
                                      ));
                                    } else {
                                      // All checks passed, save the user data
                                      FirebaseFirestore.instance.collection("UsersProfile").add({
                                        'firstName': firstNameController.text,
                                        'lastName': lastNameController.text,
                                        'phoneNumber': phoneNumberController.text,
                                        'age': ageController.text,
                                        'batch': batchController.text,
                                        'cnic': cnicController.text,
                                        'department': departmentController.text,
                                        'email': emailController.text,
                                        'universityCardNumber': universityCardNumberController.text,
                                      });

                                      // Show success message
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Success"),
                                            content: Text("You have successfully registered!"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("OK"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  });
                                }
                              });
                            }
                          });
                        }
                      });
                    }
                  },
                  child: Text("Register"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
