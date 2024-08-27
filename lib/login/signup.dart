import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomnia/database.dart';
import 'package:tomnia/login/gps.dart';
import 'package:tomnia/login/login.dart';
import 'package:tomnia/model.dart';
import 'package:animations/animations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'emailconfirm.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final GlobalKey<FormState> formregister = GlobalKey();
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController passwordregister = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nationalPhotoController = TextEditingController();

  Future<ApiResponse> register(
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String password,
      String confirmPassword,
      String nationalPhoto,
      Model model) async {
    final url =
        Uri.parse('http://tomnaia.runasp.net/api/Authorization/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'confirmPassowrd': password,
        'nationalPhoto': nationalPhoto,
        "accountType": 0
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json != null && json is Map<String, dynamic>) {
        return ApiResponse.fromJson(json);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to register: ${response.reasonPhrase}');
    }
  }

  Future<ApiResponselogin> login(
      String email, String password, Model model) async {
    final url = Uri.parse('http://tomnaia.runasp.net/api/Authorization/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json != null && json is Map<String, dynamic>) {
        ApiResponselogin apiResponse = ApiResponselogin.fromJson(json);
        if (apiResponse.success && apiResponse.token != null) {
          model.setToken(apiResponse.token!);
          print(apiResponse.token!);

          await fetchCurrentUser(model);
        }
        return apiResponse;
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }

  Future<void> fetchCurrentUser(Model model) async {
    final url =
        Uri.parse('http://tomnaia.runasp.net/api/User/get-Current-user');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${model.token}',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json != null && json is Map<String, dynamic>) {
        model.setUserId(json['id']);
        model.setAccountType(json['accountType']);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to fetch user: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ensure Scaffold is present
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
                    SizedBox(height: 30),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Consumer<Model>(builder: (context, model, child) {
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
                      child: Form(
                        key: formregister,
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return ListView(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10),
                              children: [
                                const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: constraints.maxHeight * 0.04),
                                // First name and Last name
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: constraints.maxWidth * 0.01),
                                        const Text(
                                          'Name',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: firstname,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: const Color.fromRGBO(
                                                  237, 237, 237, 1),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              hintText: 'First Name',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter your first name';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            controller: lastname,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: const Color.fromRGBO(
                                                  237, 237, 237, 1),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              hintText: 'Last Name',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter your last name';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Email input
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: constraints.maxWidth * 0.01),
                                        const Text(
                                          'Email',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: email,
                                            decoration: InputDecoration(
                                              prefixIcon:
                                                  const Icon(Icons.email),
                                              filled: true,
                                              fillColor: const Color.fromRGBO(
                                                  237, 237, 237, 1),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              hintText: 'Example@gmail.com',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter your Email';
                                              } else if (!RegExp(
                                                      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                                  .hasMatch(value)) {
                                                return 'Enter a valid Email';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Phone input
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: constraints.maxWidth * 0.01),
                                        const Text(
                                          'Phone',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType: TextInputType.phone,
                                            controller: phone,
                                            decoration: InputDecoration(
                                              prefixIcon:
                                                  const Icon(Icons.phone),
                                              filled: true,
                                              fillColor: const Color.fromRGBO(
                                                  237, 237, 237, 1),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              hintText: '123 456 7890',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter your phone number';
                                              } else if (!RegExp(
                                                      r'^01[0-2|5]{1}[0-9]{8}$')
                                                  .hasMatch(value)) {
                                                return 'Enter a valid phone number';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Password input
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: constraints.maxWidth * 0.01),
                                        const Text(
                                          'Password',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: passwordregister,
                                            obscureText: model.obscure!,
                                            decoration: InputDecoration(
                                              prefixIcon:
                                                  const Icon(Icons.lock),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  model.obscure!
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                ),
                                                onPressed: () {
                                                  model.changeobscure();
                                                },
                                              ),
                                              errorMaxLines: 2,
                                              filled: true,
                                              fillColor: const Color.fromRGBO(
                                                  237, 237, 237, 1),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              hintText: '********',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter your Password';
                                              }
                                              if (!value.contains(
                                                      RegExp(r'[A-Z]')) ||
                                                  !value.contains(
                                                      RegExp(r'[0-9]')) ||
                                                  !value.contains(RegExp(
                                                      r'[!@#$%^&*(),.?":{}|<>]'))) {
                                                return 'Password must contain one upper case letter, one special symbol, one number at least';
                                              }
                                              if (value.length < 8) {
                                                return 'Password must be more than 8 characters';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Confirm Password input
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: constraints.maxWidth * 0.01),
                                        const Text(
                                          'Confirm Password',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                confirmPasswordController,
                                            obscureText: model.obscure!,
                                            decoration: InputDecoration(
                                              prefixIcon:
                                                  const Icon(Icons.lock),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  model.obscure!
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                ),
                                                onPressed: () {
                                                  model.changeobscure();
                                                },
                                              ),
                                              errorMaxLines: 2,
                                              filled: true,
                                              fillColor: const Color.fromRGBO(
                                                  237, 237, 237, 1),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              hintText: '********',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Confirm your Password';
                                              }
                                              if (value !=
                                                  passwordregister.text) {
                                                return 'Passwords do not match';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // National Photo input
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: constraints.maxWidth * 0.01),
                                        const Text(
                                          'National Photo',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: nationalPhotoController,
                                            decoration: InputDecoration(
                                              prefixIcon:
                                                  const Icon(Icons.photo),
                                              filled: true,
                                              fillColor: const Color.fromRGBO(
                                                  237, 237, 237, 1),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              hintText: 'National Photo URL',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter the National Photo URL';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: constraints.maxHeight * 0.07),

                                // Sign up button and navigation to another screen
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          const Color.fromRGBO(4, 56, 96, 1),
                                        ),
                                        fixedSize: MaterialStateProperty.all(
                                          Size(
                                            constraints.maxWidth * 0.8,
                                            constraints.maxHeight * 0.064,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (formregister.currentState!
                                            .validate()) {
                                          try {
                                            ApiResponse response =
                                                await register(
                                              firstname.text,
                                              lastname.text,
                                              email.text,
                                              phone.text,
                                              passwordregister.text,
                                              confirmPasswordController.text,
                                              nationalPhotoController.text,
                                              model,
                                            );
                                            if (response.success) {
                                              login(email.text,
                                                  passwordregister.text, model);

                                              Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  pageBuilder: (context,
                                                          animation,
                                                          secondaryAnimation) =>
                                                      const Emailconfirm(),
                                                  transitionsBuilder: (context,
                                                      animation,
                                                      secondaryAnimation,
                                                      child) {
                                                    return SharedAxisTransition(
                                                      animation: animation,
                                                      secondaryAnimation:
                                                          secondaryAnimation,
                                                      transitionType:
                                                          SharedAxisTransitionType
                                                              .horizontal,
                                                      child: child,
                                                    );
                                                  },
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 500),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(response
                                                          .message ??
                                                      'Registration failed.'),
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Registration failed: $e'),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: const Text(
                                        'Sign up',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                        height: constraints.maxHeight * 0.015),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(_createRoute());
                                      },
                                      child: const Text(
                                        'Already have an account?',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                128, 128, 128, 1)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Login(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
