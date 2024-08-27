// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tomnia/Homedriver/homedriver.dart';
import 'package:tomnia/Homepassenger/homepassenger.dart';
import 'dart:async';
import 'package:tomnia/classes.dart';
import 'onboarding/firstscreen.dart';

class Loadscreen extends StatefulWidget {
  const Loadscreen({super.key});

  @override
  State<Loadscreen> createState() => _LoadscreenState();
}

class _LoadscreenState extends State<Loadscreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen(context);
  }

  Future<void> _navigateToNextScreen(BuildContext context) async {
    bool hasSeenOnboarding = await SharedPreferencesHelper.getSeen();
    await Future.delayed(const Duration(seconds: 4)); 
    if (!mounted) return;
    if (hasSeenOnboarding) {
      int userType = await SharedPreferencesHelper.getUserType();
      if (userType == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  Homedriver()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const Homepassenger()),
        );
      }
    } else {
      // SharedPreferencesHelper.setSeen(true);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Firstscreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/backgroundload.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return const SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Tomnaia',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Sail'),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
