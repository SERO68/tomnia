import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:tomnia/Homedriver/earnings.dart';
import 'package:tomnia/model.dart';
import 'package:tomnia/settings.dart';

import 'homedriver.dart';


class Home extends StatelessWidget {
 

   const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Model>(
        builder: (context, navigationProvider, child) {
          return IndexedStack(
            index: navigationProvider.currentIndex,
            children: [
              Homedriver(),
              Earnings(),
              const Settings(),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<Model>(
        builder: (context, navigationProvider, child) {
          return CurvedNavigationBar(
            index: navigationProvider.currentIndex,
            height: 60.0,
            items: const <Widget>[
                 Icon(Icons.home, size: 30),
          Icon(Icons.monetization_on, size: 30),
          Icon(Icons.settings, size: 30),
            ],
            color: Colors.white,
            buttonBackgroundColor: Colors.white,
            backgroundColor: Colors.blueAccent,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 600),
            onTap: (index) {
              navigationProvider.setIndex(index);
            },
            letIndexChange: (index) => true,
          );
        },
      ),
    );
    
  }
}
