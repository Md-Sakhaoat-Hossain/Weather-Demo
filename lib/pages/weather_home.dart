import 'package:weather_app/pages/settings.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_providers.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  @override
  void didChangeDependencies() {
    Provider.of<WeatherProvider>(context, listen: false).getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          return provider.hasDataLoaded
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentWeatherSection(provider, context),
                _forecastWeatherSection(provider, context),
              ],
            ),
          )
              : Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _currentWeatherSection(
      WeatherProvider provider, BuildContext context) {
    return Column(
      children: [
        Text(
          getFormattedDateTime(provider.currentWeather!.dt!),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          '${provider.currentWeather!.name}, ${provider.currentWeather!.sys!.country}',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
                '$iconUrlPrefix${provider.currentWeather!.weather![0].icon}$iconUrlSuffix'),
            Text(
              '${provider.currentWeather!.main!.temp!.toStringAsFixed(0)}$degree${provider.unitSymbol}',
              style: const TextStyle(
                fontSize: 80,
              ),
            ),
          ],
        ),
        Text(
          'feels like: ${provider.currentWeather!.main!.feelsLike!.toStringAsFixed(0)}$degree$celsius',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        Text(
          provider.currentWeather!.weather![0].description!,
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  Widget _forecastWeatherSection(
      WeatherProvider provider, BuildContext context) {
    final forecastItemList = provider.forecastWeather!.list!;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecastItemList.length,
        itemBuilder: (context, index) {
          final item = forecastItemList[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Text(getFormattedDateTime(item.dt!, pattern: 'EEE HH:mm')),
                  Image.network(
                      '$iconUrlPrefix${item.weather![0].icon}$iconUrlSuffix'),
                  Text(
                      '${item.main!.tempMax!.toStringAsFixed(0)}/${item.main!.tempMin!.toStringAsFixed(0)}$degree${provider.unitSymbol}'),
                  Text(item.weather![0].description!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
