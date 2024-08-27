import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:tomnia/Homepassenger/homepassenger.dart';

class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  _ProfilePictureScreenState createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  File? _image;

  final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJzZXJvYWxleEB5YWhvby5jb20iLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjFiNjYwYWVlLTBiMmEtNGM1NC04ZGY4LTIzZTgyYzlmMjc3YiIsImp0aSI6IjEzYTY2ODBiLWNiNDgtNGY0Ni05ZmY3LTI0OWFiYmRjMTcwMSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlBhc3NlbmdlciIsImV4cCI6MTcxODE1NjMzMSwiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NzE3NC8iLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo1MTczLyJ9.7a3uBlTsTPcnK3Td_D_N8IRaTpm45X8encAbIPwEMvI';

  Future<void> updateProfilePicture(String token, File imageFile) async {
    final url = Uri.parse('http://tomnaia.runasp.net/api/User/update-picture');
    final request = http.MultipartRequest('PUT', url)
      ..headers['Authorization'] = 'Bearer $token'  // Corrected header
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'), // Adjust based on your image type
      ));
  
    final response = await request.send();
  
    if (response.statusCode == 200) {
      print('Profile picture updated successfully.');
    } else {
      final responseBody = await response.stream.bytesToString();    
      print('${response.reasonPhrase}, $responseBody');
      throw Exception('Failed to update profile picture: ${response.reasonPhrase}, $responseBody');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _accept() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a profile picture.'),
        ),
      );
      return;
    }

    try {
      await updateProfilePicture(token, _image!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Homepassenger(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile picture: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    'Tomnaia',
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Sail',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              _image != null ? FileImage(_image!) : null,
                          child: _image == null
                              ? const Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Add your profile picture',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.01,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            backgroundColor: const MaterialStatePropertyAll(
                                Color.fromRGBO(4, 56, 96, 1)),
                            fixedSize: MaterialStatePropertyAll(Size(
                                constraints.maxWidth * 0.8,
                                constraints.maxHeight * 0.064))),
                        onPressed: _accept,
                        child: const Text(
                          'Accept',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'You can change it later',
                        style: TextStyle(
                          color: Colors.grey,
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
  }
}
