import 'package:flutter/material.dart';
import 'package:tomnia/driver%20form/firstform.dart';

import '../classes.dart';
import 'takepic.dart';

class Usertype extends StatelessWidget {
  const Usertype({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'images/Startled-rafiki.png',
                              ),
                              const Text(
                                'Are you a Driver or a Passenger?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    backgroundColor:
                                        const MaterialStatePropertyAll(
                                            Color.fromRGBO(4, 56, 96, 1)),
                                    fixedSize: MaterialStatePropertyAll(Size(
                                        constraints.maxWidth * 0.8,
                                        constraints.maxHeight * 0.064))),
                                onPressed: () {
                                  SharedPreferencesHelper.setUserType(
                                      'passenger');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ProfilePictureScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Passenger',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.02,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    backgroundColor:
                                        const MaterialStatePropertyAll(
                                            Color(0xFFF5F5F5)),
                                    fixedSize: MaterialStatePropertyAll(Size(
                                        constraints.maxWidth * 0.8,
                                        constraints.maxHeight * 0.064))),
                                onPressed: () {   SharedPreferencesHelper.setUserType(
                                      'Driver');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Firstform(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Driver',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.02,
                              ),
                              const Text(
                                'You Can Change It Later',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 117, 117, 117),
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
