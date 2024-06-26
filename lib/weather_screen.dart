import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  late Future<Map<String, dynamic>> weather;
  String cityName = "Nyabihu";
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      // city to  get weather
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

  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  final border = const OutlineInputBorder(
    borderSide: BorderSide.none, // Transparent border
    borderRadius: BorderRadius.all(
      Radius.circular(12),
    ),
  );

  handleSearch() {
    final city = _controller.text.toLowerCase();
    setState(() {
      cityName = city;
      weather = getCurrentWeather();
    });
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
              setState(() {
                weather = getCurrentWeather();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
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
          final currentWeatherData = data["list"][0];

          final double currentTemp =
              currentWeatherData["main"]["temp"] - 273.15;
          final currentSky = currentWeatherData["weather"][0]["main"];
          final currentPressure = currentWeatherData["main"]["pressure"];
          final currentHumidity = currentWeatherData["main"]["humidity"];
          final currentWind = currentWeatherData["wind"]["speed"];
          final hourlyForecasts = data["list"];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _controller,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter city name",
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      filled: true,
                      border: border,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextButton(
                    onPressed: handleSearch,
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(
                          double.infinity,
                          50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        )),
                    child: const Text("search"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
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
                                  "${currentTemp.toStringAsPrecision(2)} °C ",
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Icon(
                                  currentSky == "Clouds" || currentSky == "Rain"
                                      ? Icons.cloud
                                      : Icons.sunny,
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
                    "Hourly Forecast",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),

                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       for (int i = 0; i < 5; i++)
                  //         HourlyForecastItem(
                  //           icon: hourlyForecasts[i]["weather"][0]["main"] ==
                  //                       "Clouds" ||
                  //                   currentSky == "Rain"
                  //               ? Icons.cloud
                  //               : Icons.sunny,
                  //           temperature:
                  //               hourlyForecasts[i]["main"]["temp"].toString(),
                  //           time: hourlyForecasts[i]["dt_txt"]
                  //               .split(" ")[1]
                  //               .toString(),
                  //         )
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hourlyForecasts.length,
                      itemBuilder: (context, index) {
                        final hourlyForecast = hourlyForecasts[index + 1];
                        final hourlySky =
                            hourlyForecasts[index + 1]["weather"][0]["main"];
                        final double hourlyTemp =
                            hourlyForecasts[index + 1]["main"]["temp"] - 273.15;
                        final time =
                            DateTime.parse(hourlyForecast["dt_txt"].toString());
                        return HourlyForecastItem(
                          icon: hourlySky == "Clouds" || currentSky == "Rain"
                              ? Icons.cloud
                              : Icons.sunny,
                          temperature:
                              "${hourlyTemp.toStringAsPrecision(2)} °C",
                          time: DateFormat.j().format(time),
                        );
                      },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInformation(
                        icon: Icons.water_drop,
                        label: "Humidity",
                        value: currentHumidity.toString(),
                      ),
                      AdditionalInformation(
                        icon: Icons.air,
                        label: "Wind",
                        value: currentWind.toString(),
                      ),
                      AdditionalInformation(
                        icon: Icons.beach_access,
                        label: "Pressure",
                        value: currentPressure.toString(),
                      ),
                    ],
                  )
                  // weather forecast cards
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
