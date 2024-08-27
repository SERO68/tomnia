import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tomnia/Homedriver/home.dart';
import 'package:tomnia/driver%20form/carform.dart';
import 'package:tomnia/driver%20form/driverform.dart';
import 'package:tomnia/model.dart';

class Firstform extends StatelessWidget {
  Firstform({super.key});

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
          child: Column(
            children: [
              const Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tomnaia',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontFamily: 'Sail',
                        fontWeight: FontWeight.normal,
                        fontSize: 50,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Material(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              'Registration',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.06),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: const Driverform(),
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: constraints.maxWidth * 0.95,
                                height: constraints.maxHeight * 0.13,
                                child: const Card(
                                  elevation: 4.0,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Driver Information',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Icon(Icons.arrow_forward_ios)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(17.0),
                                  child: Text(
                                    'Your Basic Information',
                                    style: TextStyle(
                                      color: Color(0xFF626262),
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: const Carform(),
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: constraints.maxWidth * 0.95,
                                height: constraints.maxHeight * 0.13,
                                child: const Card(
                                  elevation: 4.0,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Car Information',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Icon(Icons.arrow_forward_ios)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(17.0),
                                  child: Text(
                                    'Your Car Information',
                                    style: TextStyle(
                                      color: Color(0xFF626262),
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Text(
                              'By clicking this button you agree to our terms and privacy settings',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Consumer<Model>(
                              builder: (context, model, child) {
                                return ElevatedButton(
                                  onPressed: model.isSubmitEnabled
                                      ? () {
                                          if (!model.driverFormCompleted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Please fill out the driver information form.'),
                                              ),
                                            );
                                          } else if (!model.carFormCompleted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Please fill out the car information form.'),
                                              ),
                                            );
                                          } else {
                                           Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child:  Home(),
                                  ),
                                );
                                          }
                                        }
                                      : null,
                                  style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    backgroundColor: const MaterialStatePropertyAll(
                                      Color.fromRGBO(4, 56, 96, 1),
                                    ),
                                    fixedSize: MaterialStatePropertyAll(
                                      Size(constraints.maxWidth * 0.8, constraints.maxHeight * 0.064),
                                    ),
                                  ),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
