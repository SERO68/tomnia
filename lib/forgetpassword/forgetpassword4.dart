import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Forgetpassword4 extends StatelessWidget {
  Forgetpassword4({super.key});
  final GlobalKey<FormState> resetpassword = GlobalKey();
  final TextEditingController passwordrest1 = TextEditingController();
  final TextEditingController passwordrest2 = TextEditingController();
  String? password;
  String? confirmPassword;
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
                    'Set a new password',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.01,
                  ),
                  const Text(
                    'Create a new password. Ensure it differs from previous ones for security',
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.03,
                  ),
                  Form(
                    key: resetpassword,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  'Password',
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
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: passwordrest1,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      errorMaxLines: 2,
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
                                      hintText: '********'),
                                  onChanged: (value) {
                                    password = value;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter your Password';
                                    }
                                    if (!value.contains(RegExp(r'[A-Z]')) ||
                                        !value.contains(RegExp(r'[0-9]')) ||
                                        !value.contains(RegExp(
                                            r'[!@#$%^&*(),.?":{}|<>]'))) {
                                      return 'Password must contain one upper case letter , one special sympol , one number at least ';
                                    }
                                    if (value.length < 8) {
                                      return 'Password must be more than 8 ';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.03,
                            ),
                            const Row(
                              children: [
                                Text(
                                  'Confirm Password',
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
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: passwordrest2,
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
                                      hintText: '*********'),
                                  onChanged: (value) {
                                    confirmPassword = value;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    } else if (password != confirmPassword) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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
                      onPressed: () { if (resetpassword.currentState!.validate()) {    Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Forgetpassword4()),
                        );
                      }
                 
                    
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
