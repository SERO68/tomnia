import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:tomnia/Homepassenger/homepassenger.dart';
import 'package:tomnia/model.dart';

class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  _ProfilePictureScreenState createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  File? _image;

Future<void> updateProfilePicture(Model model, File imageFile) async {
  final url = Uri.parse('http://tomnaia.runasp.net/api/User/update-picture');
  
  final request = http.MultipartRequest('PUT', url)
    ..headers['Authorization'] = 'Bearer ${model.token}'
    ..files.add(await http.MultipartFile.fromPath(
      'picture', 
      imageFile.path,
      contentType: MediaType('image', 'jpeg'), // Adjust based on your image type
    ));
  
  final response = await request.send();
  
  if (response.statusCode == 200) {
    print('Profile picture updated successfully.');
  } else {
    final responseBody = await response.stream.bytesToString();
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
      // Assuming you have a Model instance named `model` available in this context.
      await updateProfilePicture(Model(), _image!);
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
