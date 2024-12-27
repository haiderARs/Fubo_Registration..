import 'package:flutter/material.dart';
import 'SportsReg.dart';
import 'profile_screen.dart';
import 'StallReg.dart';
import 'dart:async';
import 'SportsTabScreen.dart';
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> slogans = [
    "Join the action today!",
    "Unleash your potential!",
    "Be part of the excitement!"
  ];
  int currentSloganIndex = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        currentSloganIndex = (currentSloganIndex + 1) % slogans.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Slogan ticker
            Container(
              height: 40,
              color: Colors.orange.shade100,
              child: Center(
                child: Text(
                  slogans[currentSloganIndex],
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 150),

            // Sports Registration container
            GestureDetector(
              onTap: () {
                _showOptions(context, "Sports Registration", CreateTournamentScreen());
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.sports_soccer, color: Colors.orange, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sports Registration",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Sign up to participate in exciting sports events.",
                            style: TextStyle(fontSize: 14, color: Colors.orange.shade700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Stall Registration container
            GestureDetector(
              onTap: () {
                _showOptions(context, "Stall Registration", StallRegistrationScreen());
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.store, color: Colors.orange, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Stall Registration",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Reserve your stall and showcase your products.",
                            style: TextStyle(fontSize: 14, color: Colors.orange.shade700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, String title, Widget registerPage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewDetailsScreen(title)),
                );
              },
              child: Text("View Details"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => registerPage),
                );
              },
              child: Text("Register"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SportsTabScreen()),
                );
              },
              child: Text("View Scedule"),
            ),
          ],
        );
      },
    );
  }
}

class ViewDetailsScreen extends StatelessWidget {
  final String type;
  ViewDetailsScreen(this.type);

  final Map<String, int> sportsDetails = {
    'Cricket': 3000,
    'Football': 4000,
    'Basketball': 3500,
    'Tennis': 2000,
    'Hockey': 3000,
    'Badminton': 1500,
    'Volleyball': 2500,
    'Rugby': 4000,
    'PUBG': 3000,
    'Dota 2': 4000,
    'League of Legends': 3500,
    'CS: GO': 2500,
    'Valorant': 3000,
    'Fortnite': 3500,
    'Overwatch': 4000,
    'Call of Duty': 3000,
  };

  final Map<String, double> stallDetails = {
    'Food Stall': 2000.0,
    'Clothing Stall': 1500.0,
    'Tech Gadget Stall': 2500.0,
    'Handicraft Stall': 1800.0,
  };

  final Map<String, String> sportsDescriptions = {
    'Cricket': "A bat-and-ball game played between two teams, known for its strategic play and massive popularity.",
    'Football': "A team sport played with a spherical ball, aiming to score goals against the opposing team.",
    'Basketball': "A fast-paced game where players aim to score by shooting a ball through the opponent's hoop.",
    'Tennis': "A racket sport that can be played individually or in doubles, known for its quick rallies.",
    'Hockey': "A team game played on a field or ice, using sticks to hit a puck or ball into the goal.",
    'Badminton': "A racket sport played with a shuttlecock, emphasizing agility and precision.",
    'Volleyball': "A team sport where players aim to score by hitting a ball over the net into the opponent's court.",
    'Rugby': "A physical team sport played with an oval ball, focusing on running and tackling.",
    'PUBG': "An online multiplayer battle royale game where players aim to be the last one standing.",
    'Dota 2': "A multiplayer online battle arena game known for its strategy and teamwork.",
    'League of Legends': "A competitive online game where teams battle in a fantasy-themed arena.",
    'CS: GO': "A first-person shooter game focusing on teamwork and strategic combat.",
    'Valorant': "A tactical first-person shooter game combining precise gunplay and unique character abilities.",
    'Fortnite': "A battle royale game featuring building mechanics and vibrant graphics.",
    'Overwatch': "A team-based multiplayer first-person shooter with diverse characters and roles.",
    'Call of Duty': "A first-person shooter game series known for its immersive campaigns and multiplayer modes."
  };

  @override
  Widget build(BuildContext context) {
    final details = type == "Sports Registration" ? sportsDetails : stallDetails;

    return Scaffold(
      appBar: AppBar(
        title: Text("Details for $type"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: details.length,
              itemBuilder: (context, index) {
                String key = details.keys.elementAt(index);
                return ListTile(
                  title: Text(key),
                  subtitle: Text("Price: \$${details[key]}\n${sportsDescriptions[key] ?? ''}"),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    type == "Sports Registration" ? CreateTournamentScreen() : StallRegistrationScreen(),
                  ),
                );
              },
              child: Text("Register", style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),),
            ),
          ),
        ],
      ),
    );
  }
}
