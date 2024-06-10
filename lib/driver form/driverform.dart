import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Driverform extends StatefulWidget {
  const Driverform({super.key});

  @override
  State<Driverform> createState() => _DriverformState();
}

class _DriverformState extends State<Driverform> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController idNumberController = TextEditingController();

  final TextEditingController licenseNumberController = TextEditingController();

  final TextEditingController expireDateController = TextEditingController();

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
                            'Driver Information',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildPhotoUploadSection('Add Your Photo', 'profile'),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: emailController,
                            label: 'Email',
                            icon: Icons.email,
                            hintText: 'example@gmail.com',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
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
                          _buildPhotoUploadSection('Add ID Photo', 'id'),
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:
                                  const Color.fromRGBO(4, 56, 96, 1),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Form Submitted')),
                                );
                              }
                            },
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
