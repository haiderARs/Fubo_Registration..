// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class AdminPanelScreen extends StatefulWidget {
//   @override
//   _AdminPanelScreenState createState() => _AdminPanelScreenState();
// }
//
// class _AdminPanelScreenState extends State<AdminPanelScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }
//
//   // Fetch Sports Registration Data from Firebase
//   Stream<QuerySnapshot> _getSportsRegistrationData() {
//     return FirebaseFirestore.instance.collection('SportsRegistration').snapshots();
//   }
//
//   // Fetch Stall Registration Data from Firebase
//   Stream<QuerySnapshot> _getStallRegistrationData() {
//     return FirebaseFirestore.instance.collection('StallRegistration').snapshots();
//   }
//
//   // Edit User function (This will show an alert to edit user)
//   void _editUser(String userId, String type) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Edit $type Registration'),
//           content: Text('Edit the user details here...'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 // Logic to edit the user in the database (could show an input form)
//                 Navigator.pop(context);
//               },
//               child: Text('Save Changes'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // Block User function (This will simulate blocking a user)
//   void _blockUser(String userId, String type) {
//     FirebaseFirestore.instance
//         .collection(type == 'sports' ? 'SportsRegistration' : 'StallRegistration')
//         .doc(userId)
//         .update({'status': 'blocked'}).then((value) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$type user blocked!')));
//     });
//   }
//
//   // Delete User function (This will delete the user)
//   void _deleteUser(String userId, String type) {
//     FirebaseFirestore.instance
//         .collection(type == 'sports' ? 'SportsRegistration' : 'StallRegistration')
//         .doc(userId)
//         .delete()
//         .then((value) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$type user deleted!')));
//     })
//         .catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting user: $error')));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Panel'),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: [
//             Tab(text: 'Sports Registration'),
//             Tab(text: 'Food Stall Registration'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // Sports Registration Tab
//           StreamBuilder<QuerySnapshot>(
//             stream: _getSportsRegistrationData(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (snapshot.hasError) {
//                 return Center(child: Text('Something went wrong!'));
//               }
//
//               if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
//                 return Center(child: Text('No sports registrations found.'));
//               }
//
//               final users = snapshot.data?.docs ?? [];
//               return ListView.builder(
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   var user = users[index];
//                   // Safe data access with null checks
//                   var data = user.data() as Map<String, dynamic>;
//                   String name = data['team_name'] ?? 'No Name';
//                   String contact = data['phone_number'] ?? 'No Contact';
//
//                   return ListTile(
//                     title: Text(name),
//                     subtitle: Text(contact),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit),
//                           onPressed: () => _editUser(user.id, 'Sports'),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.block),
//                           onPressed: () => _blockUser(user.id, 'sports'),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () => _deleteUser(user.id, 'sports'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//           // Stall Registration Tab
//           StreamBuilder<QuerySnapshot>(
//             stream: _getStallRegistrationData(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (snapshot.hasError) {
//                 return Center(child: Text('Something went wrong!'));
//               }
//
//               if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
//                 return Center(child: Text('No food stall registrations found.'));
//               }
//
//               final users = snapshot.data?.docs ?? [];
//               return ListView.builder(
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   var user = users[index];
//                   // Safe data access with null checks
//                   var data = user.data() as Map<String, dynamic>;
//                   String name = data['takerName'] ?? 'No Name';
//                   String contact = data['contactNumber'] ?? 'No Contact';
//
//                   return ListTile(
//                     title: Text(name),
//                     subtitle: Text(contact),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit),
//                           onPressed: () => _editUser(user.id, 'Stall'),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.block),
//                           onPressed: () => _blockUser(user.id, 'stall'),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () => _deleteUser(user.id, 'stall'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPanelScreen extends StatefulWidget {
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // Fetch Sports Registration Data from Firebase
  Stream<QuerySnapshot> _getSportsRegistrationData() {
    return FirebaseFirestore.instance.collection('SportsRegistration').snapshots();
  }

  // Fetch Stall Registration Data from Firebase
  Stream<QuerySnapshot> _getStallRegistrationData() {
    return FirebaseFirestore.instance.collection('StallRegistration').snapshots();
  }

  // Edit User function (This will show an alert to edit user)
  void _editUser(String userId, String type, Map<String, dynamic> currentData) {
    TextEditingController captainEmailController = TextEditingController(text: currentData['captain_email']);
    TextEditingController captainNameController = TextEditingController(text: currentData['captain_name']);
    TextEditingController cnicController = TextEditingController(text: currentData['cnic']);
    TextEditingController phoneNumberController = TextEditingController(text: currentData['phone_number']);
    TextEditingController dateOfRegController = TextEditingController(text: currentData['date_of_reg']);
    TextEditingController selectSportController = TextEditingController(text: currentData['select_sport']);
    TextEditingController teamMembersController = TextEditingController(text: currentData['team_members']);
    TextEditingController teamNameController = TextEditingController(text: currentData['team_name']);
    TextEditingController stallTypeController = TextEditingController(text: currentData['stallType']);
    TextEditingController takerNameController = TextEditingController(text: currentData['takerName']);
    TextEditingController contactNumberController = TextEditingController(text: currentData['contactNumber']);
    TextEditingController dateOfRegistrationController = TextEditingController(text: currentData['dateOfRegistration']);


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $type Registration'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                if (type == 'Sports')
                  ...[
                    TextField(
                      controller: captainEmailController,
                      decoration: InputDecoration(labelText: 'Captain Email'),
                    ),
                    TextField(
                      controller: captainNameController,
                      decoration: InputDecoration(labelText: 'Captain Name'),
                    ),
                    TextField(
                      controller: cnicController,
                      decoration: InputDecoration(labelText: 'CNIC'),
                    ),
                    TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                    ),
                    TextField(
                      controller: dateOfRegController,
                      decoration: InputDecoration(labelText: 'Date of Registration'),
                    ),
                    TextField(
                      controller: selectSportController,
                      decoration: InputDecoration(labelText: 'Sport Type'),
                    ),
                    TextField(
                      controller: teamMembersController,
                      decoration: InputDecoration(labelText: 'Team Members'),
                    ),
                    TextField(
                      controller: teamNameController,
                      decoration: InputDecoration(labelText: 'Team Name'),
                    ),
                  ],
                if (type == 'Stall')
                  ...[
                    TextField(
                      controller: cnicController,
                      decoration: InputDecoration(labelText: 'CNIC'),
                    ),
                    TextField(
                      controller: contactNumberController,
                      decoration: InputDecoration(labelText: 'Contact Number'),
                    ),
                    TextField(
                      controller: dateOfRegistrationController,
                      decoration: InputDecoration(labelText: 'Date of Registration'),
                    ),

                    TextField(
                      controller: stallTypeController,
                      decoration: InputDecoration(labelText: 'Stall Type'),
                    ),
                    TextField(
                      controller: takerNameController,
                      decoration: InputDecoration(labelText: 'Taker Name'),
                    ),
                  ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Map<String, dynamic> updatedData = {
                  'captain_email': captainEmailController.text,
                  'captain_name': captainNameController.text,
                  'cnic': cnicController.text,
                  'phone_number': phoneNumberController.text,
                  'date_of_reg': dateOfRegController.text,
                  'select_sport': selectSportController.text,
                  'team_members': teamMembersController.text,
                  'team_name': teamNameController.text,
                  'stallType': stallTypeController.text,
                  'takerName': takerNameController.text,
                  'contactNumber': contactNumberController.text,
                  'dateOfRegistration': dateOfRegistrationController.text,

                };

                if (type == 'Sports') {
                  FirebaseFirestore.instance
                      .collection('SportsRegistration')
                      .doc(userId)
                      .update(updatedData)
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sports user updated!')));
                    Navigator.pop(context);
                  })
                      .catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating user: $error')));
                  });
                } else {
                  FirebaseFirestore.instance
                      .collection('StallRegistration')
                      .doc(userId)
                      .update(updatedData)
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Stall user updated!')));
                    Navigator.pop(context);
                  })
                      .catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating user: $error')));
                  });
                }
              },
              child: Text('Save Changes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Block User function (This will simulate blocking a user)
  void _blockUser(String userId, String type) {
    FirebaseFirestore.instance
        .collection(type == 'sports' ? 'SportsRegistration' : 'StallRegistration')
        .doc(userId)
        .update({'status': 'blocked'}).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$type user blocked!')));
    });
  }

  // Delete User function (This will delete the user)
  void _deleteUser(String userId, String type) {
    FirebaseFirestore.instance
        .collection(type == 'sports' ? 'SportsRegistration' : 'StallRegistration')
        .doc(userId)
        .delete()
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$type user deleted!')));
    })
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting user: $error')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Sports Registration'),
            Tab(text: 'Food Stall Registration'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Sports Registration Tab
          StreamBuilder<QuerySnapshot>(
            stream: _getSportsRegistrationData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong!'));
              }

              if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                return Center(child: Text('No sports registrations found.'));
              }

              final users = snapshot.data?.docs ?? [];
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
                  // Safe data access with null checks
                  var data = user.data() as Map<String, dynamic>;
                  String name = data['team_name'] ?? 'No Name';
                  String contact = data['phone_number'] ?? 'No Contact';

                  return ListTile(
                    title: Text(name),
                    subtitle: Text(contact),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editUser(user.id, 'Sports', data),
                        ),
                        IconButton(
                          icon: Icon(Icons.block),
                          onPressed: () => _blockUser(user.id, 'sports'),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteUser(user.id, 'sports'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          // Stall Registration Tab
          StreamBuilder<QuerySnapshot>(
            stream: _getStallRegistrationData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong!'));
              }

              if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                return Center(child: Text('No food stall registrations found.'));
              }

              final users = snapshot.data?.docs ?? [];
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
                  // Safe data access with null checks
                  var data = user.data() as Map<String, dynamic>;
                  String name = data['takerName'] ?? 'No Name';
                  String contact = data['contactNumber'] ?? 'No Contact';

                  return ListTile(
                    title: Text(name),
                    subtitle: Text(contact),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editUser(user.id, 'Stall', data),
                        ),
                        IconButton(
                          icon: Icon(Icons.block),
                          onPressed: () => _blockUser(user.id, 'stall'),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteUser(user.id, 'stall'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
