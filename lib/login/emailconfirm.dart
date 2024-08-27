import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tomnia/Homepassenger/homepassenger.dart';
import 'package:http/http.dart' as http;
import 'package:tomnia/model.dart';

class Emailconfirm extends StatefulWidget {
  const Emailconfirm({super.key});

  @override
  State<Emailconfirm> createState() => _EmailconfirmState();
}

class _EmailconfirmState extends State<Emailconfirm> {
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'images/Email campaign-rafiki.png',
                              ),
                              const Text(
                                'Did you confirm email?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 36,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.03,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    backgroundColor:
                                        const MaterialStatePropertyAll(
                                            Color.fromRGBO(4, 56, 96, 1)),
                                    fixedSize: MaterialStatePropertyAll(Size(
                                        constraints.maxWidth * 0.8,
                                        constraints.maxHeight * 0.064))),
                                onPressed: () {
                                  final model = Model();
                                  fetchCurrentUser(model);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const Homepassenger(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.02,
                              ),
                              const Text(
                                'You Can Change It Later',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 117, 117, 117),
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
