import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String email;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    if (user != null) {
      email = user.email ?? '';
    }
  }

  // Function to request permission to access the gallery
  Future<void> _requestPermission() async {
    var status = await Permission.photos.request();
    if (status.isGranted) {
      _pickImage();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission to access gallery denied')),
      );
    }
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to fetch user details from Firestore and match email
  Future<Map<String, dynamic>> _fetchUserDetails() async {
    DocumentSnapshot userProfileDoc =
    await _firestore.collection('UsersProfile').doc(email).get();
    Map<String, dynamic> userProfileData = userProfileDoc.data() as Map<String, dynamic>;

    // Fetch registration details from other collections
    DocumentSnapshot sportsDoc =
    await _firestore.collection('SportsRegistration').doc(email).get();
    DocumentSnapshot stallDoc =
    await _firestore.collection('StallRegistration').doc(email).get();

    // Add the booking details to the profile
    userProfileData['sportsBooking'] =
    sportsDoc.exists ? 'Sports Registration Bookings: 1' : 'No Sports Registration';
    userProfileData['stallBooking'] =
    stallDoc.exists ? 'Stall Registration Bookings: 1' : 'No Stall Registration';

    return userProfileData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _requestPermission,
              child: _image == null
                  ? CircleAvatar(
                radius: 50,
                backgroundColor: Colors.orange,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              )
                  : CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(_image!),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<Map<String, dynamic>>(
              future: _fetchUserDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No user details found');
                }
                var userDetails = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text('First Name: ${userDetails['firstName'] ?? 'N/A'}'),
                    Text('Last Name: ${userDetails['lastName'] ?? 'N/A'}'),
                    Text('Phone Number: ${userDetails['phoneNumber'] ?? 'N/A'}'),
                    Text('Age: ${userDetails['age'] ?? 'N/A'}'),
                    Text('Batch: ${userDetails['batch'] ?? 'N/A'}'),
                    Text('Department: ${userDetails['department'] ?? 'N/A'}'),
                    Text('University Card Number: ${userDetails['universityCardNumber'] ?? 'N/A'}'),
                    Text('Email: ${userDetails['email'] ?? 'N/A'}'),
                    SizedBox(height: 20),
                    Text(userDetails['sportsBooking'] ?? 'No sports registration'),
                    Text(userDetails['stallBooking'] ?? 'No stall registration'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
