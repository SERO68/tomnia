import 'package:flutter/material.dart';

import 'forgetpassword4.dart';

class Forgetpassword3 extends StatelessWidget {
  const Forgetpassword3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
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
                    'Password Reset',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.01,
                  ),
                  const Text(
                    'Your password has been successfully reset. click confirm to set a new password',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.03,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                          backgroundColor: const MaterialStatePropertyAll(
                              Color.fromRGBO(4, 56, 96, 1)),
                          fixedSize: MaterialStatePropertyAll(Size(
                              constraints.maxWidth * 0.8,
                              constraints.maxHeight * 0.064))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Forgetpassword4()),
                        );
                      },
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
