import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomnia/database.dart';
import 'package:tomnia/forgetpassword/forgetpassword.dart';
import 'package:tomnia/login/signup.dart';
import 'package:tomnia/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formregister = GlobalKey();
    final TextEditingController emaillogin = TextEditingController();
    final TextEditingController passwordlogin = TextEditingController();

Future<String?> fetchCurrentUser(Model model) async {
  final url = Uri.parse('http://tomnaia.runasp.net/api/User/get-Current-user');
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
      return json['id']; 
    } else {
      throw Exception('Invalid response format');
    }
  } else {
    throw Exception('Failed to fetch user: ${response.reasonPhrase}');
  }
}

Future<ApiResponselogin> login(String email, String password, Model model) async {
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

       
        String? userId = await fetchCurrentUser(model);
        if (userId != null) {
          model.setUserId(userId);
        }
      }
      return apiResponse;
    } else {
      throw Exception('Invalid response format');
    }
  } else {
    throw Exception('Failed to login: ${response.reasonPhrase}');
  }
}

    return DecoratedBox(
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
              flex: 3,
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
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Column(
                                children: [
                                  Text(
                                    'Welcome Back',
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Login to your account',
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontFamily: 'Roboto',
                                      color: Color.fromARGB(255, 95, 95, 95),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),

                              // Email input
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                              width:
                                                  constraints.maxWidth * 0.1),
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
                                          TextFormField(
                                            controller: emaillogin,
                                            decoration: InputDecoration(
                                              prefixIcon:
                                                  const Icon(Icons.person),
                                              filled: true,
                                              fillColor: const Color.fromRGBO(
                                                  237, 237, 237, 1),
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    constraints.maxWidth * 0.86,
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              hintText: 'email@gmail.com',
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
                                        ],
                                      ),
                                    ],
                                  ),

                                  // Password input
                                  SizedBox(
                                      height: constraints.maxHeight * 0.04),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                              width:
                                                  constraints.maxWidth * 0.1),
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
                                          TextFormField(
                                            controller: passwordlogin,
                                            obscureText: model.obscurelogin!,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  model.obscurelogin!
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                ),
                                                onPressed: () {
                                                  model.changeobscurelogin();
                                                },
                                              ),
                                              prefixIcon:
                                                  const Icon(Icons.lock),
                                              errorMaxLines: 2,
                                              filled: true,
                                              fillColor: const Color.fromRGBO(
                                                  237, 237, 237, 1),
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    constraints.maxWidth * 0.86,
                                              ),
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
                                                return 'Enter your password';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                              width:
                                                  constraints.maxWidth * 0.4),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Forgetpassword(),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Forget Your Password?',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      128, 128, 128, 1)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Login button
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                        Color.fromRGBO(4, 56, 96, 1),
                                      ),
                                      fixedSize: MaterialStatePropertyAll(
                                        Size(constraints.maxWidth * 0.8,
                                            constraints.maxHeight * 0.064),
                                      ),
                                    ),
                                 onPressed: () async {
  if (formregister.currentState!.validate()) {
    try {
      ApiResponselogin response = await login(emaillogin.text, passwordlogin.text, model);
      if (response.success) {
        // Navigate to the next screen or show a success message
        // Display or use the user ID as needed
      } else {
        // Show error message
      }
    } catch (e) {
      // Handle error
    }
  }
},
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                      height: constraints.maxHeight * 0.02),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(_createRoute());
                                    },
                                    child: const Text(
                                      'Don\'t have an account?',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(128, 128, 128, 1)),
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
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Signup(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
