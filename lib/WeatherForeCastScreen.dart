import 'package:flutter/material.dart';
import 'package:weather/weather.dart'; // Import weather package
import 'package:intl/intl.dart'; // For date formatting

class WeatherForecastScreen extends StatefulWidget {
  @override
  _WeatherForecastScreenState createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  List<Weather> weatherData = []; // Store weather data
  bool isLoading = true; // Track if the data is still being fetched

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  // Fetch weather data for the next 7 days using the weather package
  Future<void> _fetchWeatherData() async {
    final weather = WeatherFactory('76715dd56646fc53e36b5d4cd2c11b11'); // Your OpenWeatherMap API Key
    try {
      // Fetch 5-day forecast for Rawalpindi
      final data = await weather.fiveDayForecastByCityName('Rawalpindi');
      setState(() {
        weatherData = data;
        isLoading = false; // Data has been fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading if there's an error
      });
      print('Error fetching weather data: $e');
    }
  }

  // Function to get time of day based on hour
  String getTimeOfDay(DateTime dateTime) {
    int hour = dateTime.hour;
    if (hour < 12) {
      return 'Morning';
    } else if (hour < 17) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }

  // Function to provide weather-related suggestions
  String getWeatherSuggestion(String description) {
    if (description.contains("rain")) {
      return "Don't forget to bring an umbrella!";
    } else if (description.contains("clear")) {
      return "Perfect day to go out!";
    } else if (description.contains("snow")) {
      return "Wear a warm coat!";
    } else if (description.contains("cloud")) {
      return "It might be a bit gloomy, but still nice outside.";
    } else {
      return "Be prepared for unexpected weather!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('7 Day Weather Forecast'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator until data is fetched
            : weatherData.isEmpty
            ? Center(child: Text('No weather data available'))
            : ListView.builder(
          itemCount: weatherData.length,
          itemBuilder: (context, index) {
            var dayWeather = weatherData[index];
            var date = DateTime.fromMillisecondsSinceEpoch(dayWeather.date!.millisecondsSinceEpoch);
            var temperature = dayWeather.temperature?.celsius ?? 0.0;
            var description = dayWeather.weatherDescription ?? 'No Description';
            var timeOfDay = getTimeOfDay(date);
            var suggestion = getWeatherSuggestion(description);

            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 5,
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  '${DateFormat('yyyy-MM-dd').format(date)} ($timeOfDay)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$description, ${temperature.toStringAsFixed(1)}°C',
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      suggestion,
                      style: TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
