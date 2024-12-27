import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

// Define the database table and fields
final String tableName = 'tournaments';
final String columnId = 'id';
final String columnName = 'name';
final String columnProfession = 'profession';
final String columnOutdoorSport = 'outdoorSport';
final String columnESport = 'eSport';
final String columnTotalPayment = 'totalPayment';

class Tournament {
  int? id;
  String name;
  String profession;
  String outdoorSport;
  String eSport;
  double totalPayment;
  int selectedNumber;

  Tournament({
    this.id,
    required this.name,
    required this.profession,
    required this.outdoorSport,
    required this.eSport,
    required this.totalPayment,
    required this.selectedNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      columnName: name,
      columnProfession: profession,
      columnOutdoorSport: outdoorSport,
      columnESport: eSport,
      columnTotalPayment: totalPayment,
      'selectedNumber': selectedNumber,
    };
  }

  factory Tournament.fromMap(Map<String, dynamic> map) {
    return Tournament(
      id: map[columnId],
      name: map[columnName],
      profession: map[columnProfession],
      outdoorSport: map[columnOutdoorSport],
      eSport: map[columnESport],
      totalPayment: map[columnTotalPayment],
      selectedNumber: map['selectedNumber'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = p.join(await getDatabasesPath(), 'tournament.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute(''' 
        CREATE TABLE $tableName(
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnName TEXT,
          $columnProfession TEXT,
          $columnOutdoorSport TEXT,
          $columnESport TEXT,
          $columnTotalPayment REAL,
          selectedNumber INTEGER
        )
      ''');
    });
  }

  Future<int> insertTournament(Tournament tournament) async {
    Database db = await database;
    return await db.insert(tableName, tournament.toMap());
  }

  Future<List<Tournament>> getTournaments() async {
    final db = await database;
    var res = await db.query(tableName);
    return res.isNotEmpty
        ? res.map((tournament) => Tournament.fromMap(tournament)).toList()
        : [];
  }
}

class TournamentRegistrationScreen extends StatefulWidget {
  @override
  _TournamentRegistrationScreenState createState() =>
      _TournamentRegistrationScreenState();
}

class _TournamentRegistrationScreenState
    extends State<TournamentRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String profession = '';
  String outdoorSport = 'Cricket';
  String eSport = 'Football';
  double totalPayment = 0.0;
  bool isPaid = false;
  bool isSubmitEnabled = false;

  int selectedNumber = 1;

  List<String> outdoorSports = [
    'Cricket', 'Football', 'Basketball', 'Tennis', 'Volleyball', 'Baseball', 'Rugby', 'Hockey'
  ];

  List<String> eSports = [
    'Football', 'FIFA', 'Call of Duty', 'Dota 2', 'League of Legends', 'PUBG', 'Valorant', 'Rocket League'
  ];

  List<int> numbers = List.generate(15, (index) => index + 1);

  Map<String, double> sportPaymentRates = {
    'Cricket': 50.0, 'Football': 40.0, 'Basketball': 60.0, 'Tennis': 45.0, 'Volleyball': 30.0, 'Baseball': 55.0,
    'Rugby': 70.0, 'Hockey': 65.0, 'FIFA': 30.0, 'Call of Duty': 35.0, 'Dota 2': 40.0, 'League of Legends': 45.0,
    'PUBG': 25.0, 'Valorant': 40.0, 'Rocket League': 50.0,
  };

  void calculateTotalPayment() {
    setState(() {
      totalPayment = (sportPaymentRates[outdoorSport] ?? 0.0) +
          (sportPaymentRates[eSport] ?? 0.0);
    });
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate() && isSubmitEnabled) {
      Tournament newTournament = Tournament(
        name: name,
        profession: profession,
        outdoorSport: outdoorSport,
        eSport: eSport,
        totalPayment: totalPayment,
        selectedNumber: selectedNumber,
      );

      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.insertTournament(newTournament);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tournament Registered')),
      );

      _formKey.currentState!.reset();
      setState(() {
        outdoorSport = 'Cricket';
        eSport = 'Football';
        totalPayment = 0.0;
        isPaid = false;
        isSubmitEnabled = false;
      });
    }
  }

  Future<void> showPaymentDialog() async {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController pinController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pay Amount'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Enter Amount'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: pinController,
                decoration: InputDecoration(labelText: 'Enter PIN'),
                obscureText: true,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (amountController.text.isNotEmpty &&
                    pinController.text.isNotEmpty) {
                  setState(() {
                    isSubmitEnabled = true;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Pay'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
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
        title: Text('Tournament Registration'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => setState(() {
                  name = value!;
                }),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Profession',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your profession';
                  }
                  return null;
                },
                onSaved: (value) => setState(() {
                  profession = value!;
                }),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: outdoorSport,
                items: outdoorSports.map((sport) => DropdownMenuItem(
                  child: Text(sport),
                  value: sport,
                )).toList(),
                decoration: InputDecoration(
                  labelText: 'Outdoor Sport',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    outdoorSport = value!;
                    calculateTotalPayment();
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: eSport,
                items: eSports.map((sport) => DropdownMenuItem(
                  child: Text(sport),
                  value: sport,
                )).toList(),
                decoration: InputDecoration(
                  labelText: 'E-Sport',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    eSport = value!;
                    calculateTotalPayment();
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: selectedNumber,
                items: numbers.map((number) => DropdownMenuItem(
                  child: Text('$number'),
                  value: number,
                )).toList(),
                decoration: InputDecoration(
                  labelText: 'Number of Members',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedNumber = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Total Payment: \$${totalPayment.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showPaymentDialog();
                },
                child: Text('Pay Now'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: handleSubmit,
                child: Text('Submit Tournament'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
