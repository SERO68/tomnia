import 'package:flutter/material.dart';
import 'package:tomnia/login/typeuser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class Gpslocation extends StatefulWidget {
  const Gpslocation({super.key});

  @override
  State<Gpslocation> createState() => _GpslocationState();
}

class _GpslocationState extends State<Gpslocation> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey();
  bool isenabled = false;


  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    setState(() {
      _controller.text = "${place.locality}, ${place.street}, ${place.country}";
      isenabled=false;
    });
  }

  Future<void> requestPermission() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isDenied) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Location Permission Denied'),
            content: const Text(
                'This app needs location permission to function. Please allow location access in the app settings.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (status.isGranted) {
      _getCurrentLocation();
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
                                'images/Address-rafiki.png',
                              ),
                              const Text(
                                'Where are you ?',
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
                              Form(
                                key: formkey,
                                child: TextFormField(
                                  enabled: isenabled ,
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.gps_fixed),
                                    filled: true,
                                    fillColor:
                                        const Color.fromRGBO(237, 237, 237, 1),
                                    constraints: BoxConstraints(
                                        maxWidth: constraints.maxWidth * 0.86),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    labelText: 'Enter your location',
                                  ),
                                  onTap: () {
                                    requestPermission();
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your location';
                                    }
                                    return null;
                                  },
                                ),
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
                                  if (formkey.currentState!.validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Usertype(),
                                      ),
                                    );
                                  }
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
