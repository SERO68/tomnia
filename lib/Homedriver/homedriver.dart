import 'package:flutter/material.dart';
import 'package:tomnia/Homedriver/addpath.dart';
import 'package:tomnia/Homedriver/profiledriver.dart';

class Homedriver extends StatelessWidget {
  Homedriver({super.key});

  final List rides = [
    {'date': '2023-05-01', 'Riders': '10', 'Price': '100'},
    {'date': '2023-05-01', 'Riders': '10', 'Price': '100'},
    {'date': '2023-05-01', 'Riders': '10', 'Price': '100'}
  ];

  @override
  Widget build(BuildContext context) {
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
                backgroundImage: const AssetImage(
                  'images/serologo.png',
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profiledriver(),
                      ),
                    );
                  },
                ),
                )
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
                    child: Text(
                      'No rides available',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: rides.length, // Number of rides
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today,
                                            color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text('2024/11/11  10:12 PM'),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.people, color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text('5 Riders till now'),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '\$100.00',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
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
