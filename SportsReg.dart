import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'WeatherForeCastScreen.dart';

class CreateTournamentScreen extends StatefulWidget {
  @override
  _CreateTournamentScreenState createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController teamNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController captainNameController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  String selectedType = "Physical Sports";
  String? selectedSport;
  int? selectedTeamMembers;
  double generatedBill = 0.0;

  final List<String> physicalSports = [
    'Cricket', 'Football', 'Basketball', 'Tennis', 'Hockey', 'Badminton', 'Volleyball', 'Rugby'
  ];

  final List<String> eSportsGames = [
    'PUBG', 'Dota 2', 'League of Legends', 'CS: GO', 'Valorant', 'Fortnite', 'Overwatch', 'Call of Duty'
  ];

  final Map<String, double> sportPrices = {
    'Cricket': 3000, 'Football': 4000, 'Basketball': 3500, 'Tennis': 2000, 'Hockey': 3000, 'Badminton': 1500,
    'Volleyball': 2500, 'Rugby': 4000, 'PUBG': 3000, 'Dota 2': 4000, 'League of Legends': 3500, 'CS: GO': 2500,
    'Valorant': 3000, 'Fortnite': 3500, 'Overwatch': 4000, 'Call of Duty': 3000
  };

  void _updateBill(String? selectedSport) {
    setState(() {
      generatedBill = sportPrices[selectedSport] ?? 0.0;
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
                      _confirmPayment();
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



  void _confirmPayment() async {
    // Create the data map
    Map<String, dynamic> tournamentData = {
      'captain_email': emailController.text,
      'captain_name': captainNameController.text,
      'cnic': cnicController.text,
      'date_of_reg': dateController.text,
      'phone_number': phoneNumberController.text,
      'select_sport': selectedSport,
      'team_members': selectedTeamMembers?.toString() ?? '', // Convert to string
      'team_name': teamNameController.text,
    };

    // Get reference to Firestore collection
    CollectionReference sportsRegistration = FirebaseFirestore.instance.collection('SportsRegistration');

    try {
      // Check if the email is already registered
      QuerySnapshot querySnapshot = await sportsRegistration
          .where('captain_email', isEqualTo: emailController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If email exists, show an alert
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email is already registered!'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // If email doesn't exist, add the new user data
        await sportsRegistration.add(tournamentData);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tournament Created and Data Saved!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate back or to a different screen
        Navigator.pop(context);
      }
    } catch (e) {
      // Show error message if there's a failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _createTournament() {
    if (_formKey.currentState?.validate() ?? false) {
      // No DatabaseHelper used here. You can implement custom logic like saving to a list, backend, etc.
      // Printing tournament details to console (simulating database save).
      print('Tournament Created');
      print('Team Name: ${teamNameController.text}');
      print('Captain Name: ${captainNameController.text}');
      print('Sport: ${selectedSport}');
      print('Total Payment: $generatedBill');
      print('CNIC: ${cnicController.text}');
      print('Phone Number: ${phoneNumberController.text}');

      // Close the screen after successful submission
      Navigator.pop(context);
    }
  }
  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Selection'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Create Tournament'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tournament Type",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange),
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Physical Sports'),
                      leading: Radio<String>(
                        value: "Physical Sports",
                        groupValue: selectedType,
                        onChanged: (value) {
                          setState(() {
                            selectedType = value!;
                            selectedSport = null;
                            generatedBill = 0.0;
                          });
                        },
                        activeColor: Colors.orange,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('E-Sports'),
                      leading: Radio<String>(
                        value: "E-Sports",
                        groupValue: selectedType,
                        onChanged: (value) {
                          setState(() {
                            selectedType = value!;
                            selectedSport = null;
                            generatedBill = 0.0;
                          });
                        },
                        activeColor: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),

              // Team Name Field
              TextFormField(
                controller: teamNameController,
                decoration: InputDecoration(labelText: 'Team Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a team name';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), // Only allows letters and spaces
                ],
              ),

              // Captain Name Field
              TextFormField(
                controller: captainNameController,
                decoration: InputDecoration(labelText: 'Captain Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter captain name';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), // Only allows letters and spaces
                ],
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Captain email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter captain name';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._@]'))
                  , // Only allows letters and spaces
                ],
              ),

              // CNIC Field
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

              // Phone Number Field
              TextFormField(
                controller: phoneNumberController,
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

              // Team Members Field
          DropdownButtonFormField<int>(
            decoration: InputDecoration(labelText: 'Team Members'),
            value: selectedTeamMembers,
            items: List.generate(
              selectedType == "Physical Sports" ? 15 : 5,
                  (index) => DropdownMenuItem<int>(
                value: index + 1,
                child: Text((index + 1).toString()),
              ),
            ),
            onChanged: (value) {
              bool isValidSelection = true;

              if (selectedSport == 'Cricket' || selectedSport == 'Football' || selectedSport == 'Basketball' || selectedSport == 'Hockey') {
                if (value! < 11) {
                  _showAlert('In $selectedSport, only members 11 or higher can be selected.');
                  isValidSelection = false;
                }
              } else if (selectedSport == 'Tennis' || selectedSport == 'Badminton') {
                if (value! > 2) {
                  _showAlert('In $selectedSport, only members 1 or 2 can be selected.');
                  isValidSelection = false;
                }
              } else if (selectedSport == 'Volleyball') {
                if (value! < 6 || value > 8) {
                  _showAlert('In Volleyball, only members 6, 7, or 8 can be selected.');
                  isValidSelection = false;
                }
              }

              // If the selection is invalid, do not update the field value
              if (isValidSelection) {
                setState(() {
                  selectedTeamMembers = value;  // Update only if valid selection
                });
              } else {
                // If invalid, reset the value to null so the field doesn't show the invalid number
                setState(() {
                  selectedTeamMembers = null;
                });
              }
            },
            validator: (value) {
              if (value == null) {
                return 'Please select the number of team members';
              }
              return null;
            },
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

              // Sport Selection and Bill Display
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Sport'),
                value: selectedSport,
                items: (selectedType == "Physical Sports" ? physicalSports : eSportsGames)
                    .map((sport) => DropdownMenuItem<String>(
                  value: sport,
                  child: Text(sport),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSport = value;
                    selectedTeamMembers = null; // Reset team members when the sport changes
                    _updateBill(value);
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a sport';
                  }
                  return null;
                },
              ),

              // Display Generated Bill
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Generated Bill: Rs. $generatedBill',
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WeatherForecastScreen()),
                  );
                },
                child: Text('View Weather Forecast'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
