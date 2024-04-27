import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_information_item.dart';
import 'package:weather_app/secrets.dart';
import 'package:weather_app/weather_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "London";
      final res = await http.get(
        Uri.parse(
          "http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey",
        ),
      );

      final data = jsonDecode(res.body);
      if (data["cod"] != "200") {
        throw "An unexpected error occurred";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
            ),
            onPressed: () {
              print("refresh");
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapShot.hasError) {
            return Center(
              child: Text(snapShot.error.toString()),
            );
          }
          final data = snapShot.data!;
          final double currentTemp = data["list"][0]["main"]["temp"];
          final currentSky = data["list"][0]["weather"][0]["main"];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$currentTemp K ",
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Icon(
                                Icons.cloud,
                                size: 64,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),

                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HourlyForecastItem(
                        time: "00:00",
                        icon: Icons.cloud,
                        temperature: "320.12",
                      ),
                      HourlyForecastItem(
                        time: "01:00",
                        icon: Icons.sunny,
                        temperature: "275.12",
                      ),
                      HourlyForecastItem(
                        time: "02:00",
                        icon: Icons.cloud,
                        temperature: "320.12",
                      ),
                      HourlyForecastItem(
                        time: "03:03",
                        icon: Icons.cloud,
                        temperature: "320.12",
                      ),
                      HourlyForecastItem(
                        time: "03:03",
                        icon: Icons.cloud,
                        temperature: "320.12",
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformation(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: "91",
                    ),
                    AdditionalInformation(
                      icon: Icons.air,
                      label: "Wind",
                      value: "7.5",
                    ),
                    AdditionalInformation(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: "1000",
                    ),
                  ],
                )
                // weather forecast cards
              ],
            ),
          );
        },
      ),
    );
  }
}
