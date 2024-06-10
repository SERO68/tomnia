import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'loadscreen2.dart';

class Thirdscreen extends StatelessWidget {
  const Thirdscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
      Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
    const SizedBox(height: 1,),
              Column(
                children: [          Image.asset(
                'images/Startup life.gif',
              ),
                  const Text(
                    'Lets hit the Road!',
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
               const SizedBox(
                height: 10,
               ),
           
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: () {}, child: const Text('Skip',style: TextStyle(fontSize: 22,color: Color.fromRGBO(132, 132, 132, 1)),)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(180, 180, 180, 1),
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(180, 180, 180, 1),
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(4, 56, 96, 1),
                        ),
                      ),
                    ],
                  ),
                  TextButton(onPressed: () { Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const Loadscreen2(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return SharedAxisTransition(
                                  animation: animation,
                                  secondaryAnimation: secondaryAnimation,
                                  transitionType:
                                      SharedAxisTransitionType.horizontal,
                                  child: child,
                                );
                              },
                               transitionDuration: const Duration(milliseconds: 500),
                            ),
                          );}, child: const Text('Next',style: TextStyle(fontSize: 25))),
                ],
              )
            ],
          ),
        ),
      ),
    ),);
  }
}
