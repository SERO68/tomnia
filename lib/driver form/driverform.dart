import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tomnia/model.dart';

import '../database.dart';

class Driverform extends StatefulWidget {
  const Driverform({super.key});

  @override
  State<Driverform> createState() => _DriverformState();
}

class _DriverformState extends State<Driverform> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController idNumberController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController expireDateController = TextEditingController();
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController passwordregister = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nationalPhotoController = TextEditingController();

  File? profileImage;

  File? idPhoto;

  File? licensePhoto;

  final ImagePicker picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, String photoType) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        if (photoType == 'profile') {
          profileImage = File(pickedFile.path);
        } else if (photoType == 'id') {
          idPhoto = File(pickedFile.path);
        } else if (photoType == 'license') {
          licensePhoto = File(pickedFile.path);
        }
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        expireDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
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

  final model = Model();

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

  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      String profileImageBase64 = '';
      String idPhotoBase64 = '';
      String licensePhotoBase64 = '';

      if (profileImage != null) {
        final bytes = await profileImage!.readAsBytes();
        profileImageBase64 = base64Encode(bytes);
      }
      if (idPhoto != null) {
        final bytes = await idPhoto!.readAsBytes();
        idPhotoBase64 = base64Encode(bytes);
      }
      if (licensePhoto != null) {
        final bytes = await licensePhoto!.readAsBytes();
        licensePhotoBase64 = base64Encode(bytes);
      }

      final Map<String, dynamic> requestBody = {
        "firstName": firstname.text,
        "lastName": lastname.text,
        "email": email.text,
        "phoneNumber": phone.text,
        "password": passwordregister.text,
        "confirmPassowrd": confirmPasswordController.text,
        "nationalPhoto": idPhotoBase64,
        "nationalId": idNumberController.text,
        "licensePhoto": licensePhotoBase64,
        "driverLicenseNumber": licenseNumberController.text,
        "expirDate": expireDateController.text,
        "profilePicture": profileImageBase64,
        "accountType": 1
      };

      final response = await http.post(
        Uri.parse('http://tomnaia.runasp.net/api/Authorization/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        login(email.text, passwordregister.text, model);
        fetchCurrentUser(model);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Done')),
        );
        Provider.of<Model>(context, listen: false).setDriverFormCompleted(true);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.reasonPhrase}')),
        );
      }
    }
  }

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
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Consumer<Model>(
                builder: (context, model, child) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Tomnaia',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                            fontFamily: 'Sail',
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Text(
                                      'Driver Information',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    _buildPhotoUploadSection(
                                        'Add Your Photo', 'profile'),
                                    const SizedBox(height: 10),

                                    const SizedBox(height: 20),
                                    _buildTextField(
                                      controller: idNumberController,
                                      label: 'ID Number',
                                      icon: Icons.credit_card,
                                      hintText: '0000 0000 0000 0000',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your ID number';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    _buildPhotoUploadSection(
                                        'Add ID Photo', 'id'),
                                    const SizedBox(height: 10),
                                    _buildTextField(
                                      controller: licenseNumberController,
                                      label: 'Driver Licenses',
                                      icon: Icons.directions_car,
                                      hintText: 'Enter your licenses number',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your license number';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    _buildDatePickerTextField(
                                      controller: expireDateController,
                                      context: context,
                                      label: 'Expire Date',
                                      icon: Icons.calendar_today,
                                      hintText: '2024/11/11',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the expire date';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    _buildPhotoUploadSection(
                                        'Add Driver License Photo', 'license'),
                                    const SizedBox(height: 30),
                                    // First name and Last name
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: constraints.maxWidth *
                                                    0.01),
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
                                                  fillColor:
                                                      const Color.fromRGBO(
                                                          237, 237, 237, 1),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
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
                                                  fillColor:
                                                      const Color.fromRGBO(
                                                          237, 237, 237, 1),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: constraints.maxWidth *
                                                    0.01),
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
                                                  fillColor:
                                                      const Color.fromRGBO(
                                                          237, 237, 237, 1),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: constraints.maxWidth *
                                                    0.01),
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
                                                keyboardType:
                                                    TextInputType.phone,
                                                controller: phone,
                                                decoration: InputDecoration(
                                                  prefixIcon:
                                                      const Icon(Icons.phone),
                                                  filled: true,
                                                  fillColor:
                                                      const Color.fromRGBO(
                                                          237, 237, 237, 1),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: constraints.maxWidth *
                                                    0.01),
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
                                                          : Icons
                                                              .visibility_off,
                                                    ),
                                                    onPressed: () {
                                                      model.changeobscure();
                                                    },
                                                  ),
                                                  errorMaxLines: 2,
                                                  filled: true,
                                                  fillColor:
                                                      const Color.fromRGBO(
                                                          237, 237, 237, 1),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
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

                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(
                                                constraints.maxWidth * 0.8,
                                                constraints.maxHeight * 0.1),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    4, 56, 96, 1),
                                          ),
                                          onPressed: _submitForm,
                                          child: const Text(
                                            'Done',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                                                    ),
                            ),
                          ),
                        
                      
                ],)
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoUploadSection(String label, String photoType) {
    File? imageFile;
    if (photoType == 'profile') {
      imageFile = profileImage;
    } else if (photoType == 'id') {
      imageFile = idPhoto;
    } else if (photoType == 'license') {
      imageFile = licensePhoto;
    }
    String error1 = '';
    void seterror(String value) {
      error1 = value;
    }

    return FormField(
      validator: (value) {
        if (imageFile == null) {
          String error = 'Please upload a $photoType photo';
          seterror(error);
          return 'Please upload a $photoType photo';
        }
        return null;
      },
      builder: (FormFieldState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => _pickImage(ImageSource.gallery, photoType),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(imageFile, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined,
                              size: 40, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            'Upload Photo',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
              ),
            ),
            Text(
              error1,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hintText,
            filled: true,
            fillColor: const Color.fromRGBO(237, 237, 237, 1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDatePickerTextField({
    required TextEditingController controller,
    required BuildContext context,
    required String label,
    required IconData icon,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hintText,
            filled: true,
            fillColor: const Color.fromRGBO(237, 237, 237, 1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
