import 'dart:convert';

import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/forecast_weather.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class WeatherProvider extends ChangeNotifier {
  CurrentWeather? currentWeather;
  ForecastWeather? forecastWeather;
  String unit = metric;
  double latitude = 23.8041, longitude = 90.4125;
  String unitSymbol = celsius;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/';

  bool get hasDataLoaded => currentWeather != null && forecastWeather != null;

  Future<void> getData() async {
    await _getCurrentData();
    await _getForecastData();
  }

  Future<void> getTempUnitFromPref() async {
    final status = await getTempUnitStatus();
    unit = status ? imperial : metric;
    unitSymbol = status ? fahrenheit : celsius;
  }

  Future<void> _getCurrentData() async {
    await getTempUnitFromPref();
    final endUrl = 'weather?lat=$latitude&lon=$longitude&appid=$weatherApiKey&units=$unit';
    final url = Uri.parse('$baseUrl$endUrl');
    try {
      final response = await http.get(url);
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if(response.statusCode == 200) {
        currentWeather = CurrentWeather.fromJson(json);
        notifyListeners();
      } else {
        print(json['message']);
      }
    } catch(error) {
      print(error.toString());
    }
  }

  Future<void> _getForecastData() async {
    await getTempUnitFromPref();
    final endUrl = 'forecast?lat=$latitude&lon=$longitude&appid=$weatherApiKey&units=$unit';
    final url = Uri.parse('$baseUrl$endUrl');
    try {
      final response = await http.get(url);
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if(response.statusCode == 200) {
        forecastWeather = ForecastWeather.fromJson(json);
        notifyListeners();
      } else {
        print(json['message']);
      }
    } catch(error) {
      print(error.toString());
    }
  }
}