import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
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
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "300.67 °F",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Icon(
                            Icons.cloud,
                            size: 64,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Rain",
                            style: TextStyle(
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
              "Weather Forest",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Card(
                    elevation: 6,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            "03:03",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Icon(
                            Icons.cloud,
                            size: 32,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "320.12",
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // weather forecast cards
            Placeholder(
              fallbackHeight: 150,
            ),
            SizedBox(
              height: 15,
            ),
            // addition information
            Placeholder(
              fallbackHeight: 150,
            ),
          ],
        ),
      ),
    );
  }
}
