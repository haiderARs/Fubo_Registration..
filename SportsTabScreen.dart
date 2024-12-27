import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SportsTabScreen(),
    );
  }
}

class SportsTabScreen extends StatelessWidget {
  final List<String> physicalSports = [
    'Cricket', 'Football', 'Basketball', 'Tennis', 'Hockey', 'Badminton', 'Volleyball', 'Rugby'
  ];

  final List<String> eSportsGames = [
    'PUBG', 'Dota 2', 'League of Legends', 'CS: GO', 'Valorant', 'Fortnite', 'Overwatch', 'Call of Duty'
  ];

  final Map<String, List<String>> physicalSportTimetable = {
    'Cricket': ['Mon 10:00 AM, Jan 5, 2025', 'Wed 2:00 PM, Jan 7, 2025', 'Fri 5:00 PM, Jan 9, 2025'],
    'Football': ['Mon 12:00 PM, Jan 5, 2025', 'Wed 3:00 PM, Jan 7, 2025', 'Fri 4:00 PM, Jan 9, 2025'],
    'Basketball': ['Mon 2:00 PM, Jan 5, 2025', 'Tue 11:00 AM, Jan 6, 2025', 'Thu 1:00 PM, Jan 8, 2025'],
    'Tennis': ['Tue 10:00 AM, Jan 6, 2025', 'Thu 12:00 PM, Jan 8, 2025', 'Fri 3:00 PM, Jan 9, 2025'],
    'Hockey': ['Mon 1:00 PM, Jan 5, 2025', 'Wed 4:00 PM, Jan 7, 2025', 'Fri 6:00 PM, Jan 9, 2025'],
    'Badminton': ['Tue 2:00 PM, Jan 6, 2025', 'Thu 11:00 AM, Jan 8, 2025', 'Sat 10:00 AM, Jan 10, 2025'],
    'Volleyball': ['Mon 9:00 AM, Jan 5, 2025', 'Wed 2:00 PM, Jan 7, 2025', 'Fri 5:00 PM, Jan 9, 2025'],
    'Rugby': ['Tue 1:00 PM, Jan 6, 2025', 'Thu 4:00 PM, Jan 8, 2025', 'Sat 12:00 PM, Jan 10, 2025'],
  };

  final Map<String, List<String>> eSportTimetable = {
    'PUBG': ['Mon 4:00 PM, Jan 5, 2025', 'Wed 6:00 PM, Jan 7, 2025', 'Fri 7:00 PM, Jan 9, 2025'],
    'Dota 2': ['Mon 5:00 PM, Jan 5, 2025', 'Wed 7:00 PM, Jan 7, 2025', 'Fri 9:00 PM, Jan 9, 2025'],
    'League of Legends': ['Mon 6:00 PM, Jan 5, 2025', 'Tue 8:00 PM, Jan 6, 2025', 'Thu 7:00 PM, Jan 8, 2025'],
    'CS: GO': ['Tue 3:00 PM, Jan 6, 2025', 'Thu 5:00 PM, Jan 8, 2025', 'Sat 4:00 PM, Jan 10, 2025'],
    'Valorant': ['Mon 8:00 PM, Jan 5, 2025', 'Wed 9:00 PM, Jan 7, 2025', 'Fri 10:00 PM, Jan 9, 2025'],
    'Fortnite': ['Tue 7:00 PM, Jan 6, 2025', 'Thu 9:00 PM, Jan 8, 2025', 'Sat 6:00 PM, Jan 10, 2025'],
    'Overwatch': ['Mon 7:00 PM, Jan 5, 2025', 'Wed 5:00 PM, Jan 7, 2025', 'Fri 8:00 PM, Jan 9, 2025'],
    'Call of Duty': ['Tue 6:00 PM, Jan 6, 2025', 'Thu 8:00 PM, Jan 8, 2025', 'Sat 9:00 PM, Jan 10, 2025'],
  };

  final Map<String, List<String>> matchHierarchy = {
    'Cricket': ['Quarter Finals: Mon 1:00 PM, Jan 12, 2025', 'Semi Finals: Wed 3:00 PM, Jan 14, 2025', 'Final: Fri 5:00 PM, Jan 16, 2025'],
    'Football': ['Quarter Finals: Mon 2:00 PM, Jan 12, 2025', 'Semi Finals: Wed 4:00 PM, Jan 14, 2025', 'Final: Fri 6:00 PM, Jan 16, 2025'],
    'Basketball': ['Quarter Finals: Mon 3:00 PM, Jan 12, 2025', 'Semi Finals: Wed 5:00 PM, Jan 14, 2025', 'Final: Fri 7:00 PM, Jan 16, 2025'],
    'Tennis': ['Quarter Finals: Mon 10:00 AM, Jan 12, 2025', 'Semi Finals: Wed 12:00 PM, Jan 14, 2025', 'Final: Fri 3:00 PM, Jan 16, 2025'],
    'Hockey': ['Quarter Finals: Mon 1:00 PM, Jan 12, 2025', 'Semi Finals: Wed 3:00 PM, Jan 14, 2025', 'Final: Fri 6:00 PM, Jan 16, 2025'],
    'Badminton': ['Quarter Finals: Tue 3:00 PM, Jan 13, 2025', 'Semi Finals: Thu 1:00 PM, Jan 15, 2025', 'Final: Sat 5:00 PM, Jan 17, 2025'],
    'Volleyball': ['Quarter Finals: Mon 11:00 AM, Jan 12, 2025', 'Semi Finals: Wed 3:00 PM, Jan 14, 2025', 'Final: Fri 6:00 PM, Jan 16, 2025'],
    'Rugby': ['Quarter Finals: Tue 1:00 PM, Jan 13, 2025', 'Semi Finals: Thu 4:00 PM, Jan 15, 2025', 'Final: Sat 3:00 PM, Jan 17, 2025'],
  };

  final Map<String, List<String>> eSportMatchHierarchy = {
    'PUBG': ['Quarter Finals: Mon 3:00 PM, Jan 12, 2025', 'Semi Finals: Wed 6:00 PM, Jan 14, 2025', 'Final: Fri 9:00 PM, Jan 16, 2025'],
    'Dota 2': ['Quarter Finals: Mon 4:00 PM, Jan 12, 2025', 'Semi Finals: Wed 7:00 PM, Jan 14, 2025', 'Final: Fri 10:00 PM, Jan 16, 2025'],
    'League of Legends': ['Quarter Finals: Mon 5:00 PM, Jan 12, 2025', 'Semi Finals: Tue 8:00 PM, Jan 13, 2025', 'Final: Thu 8:00 PM, Jan 15, 2025'],
    'CS: GO': ['Quarter Finals: Tue 2:00 PM, Jan 13, 2025', 'Semi Finals: Thu 5:00 PM, Jan 15, 2025', 'Final: Sat 8:00 PM, Jan 17, 2025'],
    'Valorant': ['Quarter Finals: Mon 7:00 PM, Jan 12, 2025', 'Semi Finals: Wed 9:00 PM, Jan 14, 2025', 'Final: Fri 11:00 PM, Jan 16, 2025'],
    'Fortnite': ['Quarter Finals: Tue 6:00 PM, Jan 13, 2025', 'Semi Finals: Thu 9:00 PM, Jan 15, 2025', 'Final: Sat 10:00 PM, Jan 17, 2025'],
    'Overwatch': ['Quarter Finals: Mon 6:00 PM, Jan 12, 2025', 'Semi Finals: Wed 5:00 PM, Jan 14, 2025', 'Final: Fri 9:00 PM, Jan 16, 2025'],
    'Call of Duty': ['Quarter Finals: Tue 5:00 PM, Jan 13, 2025', 'Semi Finals: Thu 8:00 PM, Jan 15, 2025', 'Final: Sat 10:00 PM, Jan 17, 2025'],
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 2 tabs: Physical Sports and eSports
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sports Timetable & Match Hierarchy'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Physical Sports'),
              Tab(text: 'eSports'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Physical Sports Tab
            SportsDetailsScreen(
              sportsList: physicalSports,
              timetable: physicalSportTimetable,
              matchHierarchy: matchHierarchy,
            ),

            // eSports Tab
            SportsDetailsScreen(
              sportsList: eSportsGames,
              timetable: eSportTimetable,
              matchHierarchy: eSportMatchHierarchy,
            ),
          ],
        ),
      ),
    );
  }
}

class SportsDetailsScreen extends StatelessWidget {
  final List<String> sportsList;
  final Map<String, List<String>> timetable;
  final Map<String, List<String>> matchHierarchy;

  SportsDetailsScreen({
    required this.sportsList,
    required this.timetable,
    required this.matchHierarchy,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sportsList.length,
      itemBuilder: (context, index) {
        String sport = sportsList[index];
        List<String> times = timetable[sport] ?? [];
        List<String> hierarchy = matchHierarchy[sport] ?? [];

        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(sport),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Timetable:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...times.map((time) => Text(time)).toList(),
                      SizedBox(height: 10),
                      Text('Match Hierarchy:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...hierarchy.map((match) => Text(match)).toList(),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              title: Text(sport, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...times.map((time) => Text(time)),
                  if (hierarchy.isNotEmpty) SizedBox(height: 8),
                  if (hierarchy.isNotEmpty) Text('Click for Match Hierarchy', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
