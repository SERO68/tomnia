import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tomnia/Homepassenger/homepassenger.dart';

class Carform extends StatefulWidget {
  const Carform({super.key});

  @override
  State<Carform> createState() => _CarformState();
}

class _CarformState extends State<Carform> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController yearproduction = TextEditingController();
  final TextEditingController carmodel = TextEditingController();
  final TextEditingController carcapacity = TextEditingController();
  final TextEditingController cartype = TextEditingController();
  final TextEditingController licenseStatus = TextEditingController();
  final TextEditingController driverId = TextEditingController();

  File? carImage;
  File? licensePhoto;

  final ImagePicker picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, String photoType) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        if (photoType == 'Car') {
          carImage = File(pickedFile.path);
        } else if (photoType == 'license') {
          licensePhoto = File(pickedFile.path);
        }
      }
    });
  }

  Future<void> createVehicle() async {
    final url = Uri.parse('http://tomnaia.runasp.net/api/Vehicle/CreateVehicle');

    String carImageBase64 = '';
    String licensePhotoBase64 = '';

    if (carImage != null) {
      carImageBase64 = base64Encode(await carImage!.readAsBytes());
    }

    if (licensePhoto != null) {
      licensePhotoBase64 = base64Encode(await licensePhoto!.readAsBytes());
    }

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'capacity': int.parse(carcapacity.text),
        'model': carmodel.text,
        'year': yearproduction.text,
        'vehicleType': cartype.text,
        'photolicense': licensePhotoBase64,
        'photoVehicle': carImageBase64,
        'licenseStatus': licenseStatus.text,
        'driverId': driverId.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Vehicle created successfully.');
    } else {
      throw Exception('Failed to create vehicle: ${response.reasonPhrase}');
    }
  }

  void _accept() async {
    if (formKey.currentState!.validate()) {
      if (carImage == null || licensePhoto == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload all required photos.'),
          ),
        );
        return;
      }

      try {
        await createVehicle();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Homepassenger(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create vehicle: $e'),
          ),
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
          child: SingleChildScrollView(
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Car Information',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildPhotoUploadSection(
                              'Add Your Car Photo', 'Car'),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: yearproduction,
                            label: 'Year of Production',
                            hintText: '2020',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your car year of production';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: carmodel,
                            label: 'Car Model',
                            hintText: 'Camaro',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Car Model';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: cartype,
                            label: 'Car Type',
                            hintText: 'Car',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Car Type';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: carcapacity,
                            label: 'Car Capacity',
                            hintText: '10',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Car Capacity';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: licenseStatus,
                            label: 'License Status',
                            hintText: 'Active',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your License Status';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: driverId,
                            label: 'Driver ID',
                            hintText: '12345',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Driver ID';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildPhotoUploadSection(
                              'Add Car License Photo', 'license'),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:
                                  const Color.fromRGBO(4, 56, 96, 1),
                            ),
                            onPressed: _accept,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoUploadSection(String label, String photoType) {
    File? imageFile;
    if (photoType == 'Car') {
      imageFile = carImage;
    } else if (photoType == 'license') {
      imageFile = licensePhoto;
    }

    return FormField(
      validator: (value) {
        if (imageFile == null) {
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
            if (state.hasError)
              Text(
                state.errorText!,
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
}
