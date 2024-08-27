// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:tomnia/login/signup.dart';
import 'package:tomnia/login/typeuser.dart';

class Loadscreen2 extends StatefulWidget {
  const Loadscreen2({super.key});

  @override
  State<Loadscreen2> createState() => _Loadscreen2State();
}

class _Loadscreen2State extends State<Loadscreen2> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen(context);
  }

  Future<void> _navigateToNextScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2)); 
    if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  Usertype()),
        );
     
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


