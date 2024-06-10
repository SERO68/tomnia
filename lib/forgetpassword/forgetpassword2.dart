import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomnia/model.dart';
import 'forgetpassword3.dart';

class Forgetpassword2 extends StatefulWidget {
  const Forgetpassword2({super.key});

  @override
  State<Forgetpassword2> createState() => _Forgetpassword2State();
}

class _Forgetpassword2State extends State<Forgetpassword2> {
  String currentText = "";
  final formKey = GlobalKey<FormState>();


  void navigateToNextScreen(BuildContext context) {
    if (formKey.currentState!.validate()) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Forgetpassword3()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Consumer<Model>(
              builder: (context, model, child) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back)),
                        ],
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.03,
                      ),
                      const Text(
                        'Check your Email',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.01,
                      ),
                      const Text(
                        'We sent a reset message to your Email , Please click on the link on it ',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
                     
                  
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
