import 'package:flutter/material.dart';

import 'forgetpassword2.dart';

class Forgetpassword extends StatelessWidget {
  Forgetpassword({super.key});
  final GlobalKey<FormState> resetpassword = GlobalKey();
  final TextEditingController emailreset = TextEditingController();
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
                    'Forget Password',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.01,
                  ),
                  const Text(
                    'Please enter your Email to reset the password',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.03,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'Your Email',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          SizedBox(height: constraints.maxHeight * 0.01,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Form(
                                key: resetpassword,
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: emailreset,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color.fromRGBO(
                                          237, 237, 237, 1),
                                      constraints: BoxConstraints(
                                          maxWidth:
                                              constraints.maxWidth * 0.86),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      hintText: 'example@gmail.com'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Email';
                                    }
                                    return null;
                                   },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.03,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          backgroundColor: const MaterialStatePropertyAll(
                              Color.fromRGBO(4, 56, 96, 1)),
                          fixedSize: MaterialStatePropertyAll(Size(
                              constraints.maxWidth * 0.8,
                              constraints.maxHeight * 0.064))),
                      onPressed: () {
                        if (resetpassword.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Forgetpassword2()),
                          );
                        }
                      },
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
