import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomnia/Homedriver/addpath.dart';
import 'package:tomnia/Homedriver/profiledriver.dart';
import 'package:tomnia/model.dart';
import 'package:tomnia/database.dart';
import 'package:http/http.dart' as http;

class Homedriver extends StatefulWidget {
  @override
  _HomedriverState createState() => _HomedriverState();
}

class _HomedriverState extends State<Homedriver> {
  List<Ride> rides = [];

  Future<List<Ride>> fetchDriverRide(String driverId, String token) async {
    final url = Uri.parse('http://tomnaia.runasp.net/api/Rides/driver/$driverId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      List<Ride> rides = jsonList.map((json) => Ride.fromJson(json)).toList();
      return rides;
    } else {
      throw Exception('Failed to load rides for driver');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDriverRides();
  }

  Future<void> fetchDriverRides() async {
    try {
      final model = Provider.of<Model>(context, listen: false);
      String driverId = model.userId!;

      List<Ride> fetchedRides = await fetchDriverRide(driverId, model.token!);

      setState(() {
        rides = fetchedRides;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context).currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tomnaia',
              style: TextStyle(
                fontFamily: 'Sail',
                fontSize: 30,
                color: Color.fromARGB(255, 38, 37, 136),
              ),
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(
                'http://tomnaia.runasp.net${model?.profilePicture ?? ''}',
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profiledriver()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Rides',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: rides.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: rides.length,
                    itemBuilder: (context, index) {
                      final ride = rides[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today,
                                            color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text(
                                            '${ride.startTime.year}/${ride.startTime.month}/${ride.startTime.day} ${ride.startTime.hour}:${ride.startTime.minute}'),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.people, color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text('${ride.rider} Riders till now'),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '\$${ride.fare}',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Pickup Location: ${ride.pickupLocation}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF043860),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Addpath()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
