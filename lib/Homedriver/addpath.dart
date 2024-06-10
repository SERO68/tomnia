import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tomnia/Homedriver/definepath.dart';
import 'package:tomnia/Homedriver/earnings.dart';
import 'package:tomnia/Homedriver/homedriver.dart';
import 'package:tomnia/Homedriver/profiledriver.dart';
import '../model.dart';

class Addpath extends StatefulWidget {
  const Addpath({super.key});

  @override
  State<Addpath> createState() => _AddpathState();
}

class _AddpathState extends State<Addpath> {
  final pages = [
    Homedriver(),
    Earnings(),
    const Profiledriver(),
  ];
  LatLng? _currentLatLng;
  late LatLng _currentLatLng1;

  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool permissionGranted = await _locationService.handleLocationPermission();
    if (permissionGranted) {
      Position position = await _locationService.getCurrentPosition();
      setState(() {
        _currentLatLng = LatLng(position.latitude, position.longitude);
        _currentLatLng1 = LatLng(position.latitude, position.longitude);
      });
    } else {
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text(
            'Location permissions are required to show your current location on the map. Please grant permissions in the app settings.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(bottomNavigationBar: CurvedNavigationBar(
        index: Provider.of<Model>(context).currentIndex,
        height: 60.0,
        items: const <Widget>[
    Icon(Icons.home, size: 30),
          Icon(Icons.monetization_on, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          Provider.of<Model>(context, listen: false).setIndex(index);
          Navigator.pop(context);
        },
        letIndexChange: (index) => true,
      ),
    
      appBar: AppBar(
        title: const Text('Tomnaia'),
      ),
      body: Stack(
        children: [
          _currentLatLng == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  options: MapOptions(
                    initialCenter: _currentLatLng1,
                    initialZoom: 15.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                            point: _currentLatLng!,
                            child: Image.asset(
                              'images/sedan.png',
                              width: 40,
                              height: 40,
                            )),
                      ],
                    ),
                  ],
                ),
          LayoutBuilder(builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: constraints.maxHeight * 0.07,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(Size(
                          constraints.maxWidth * 0.8,
                          constraints.maxHeight * 0.03)),
                    ),
                    onPressed: () {
                       Provider.of<Model>(context, listen: false).setlocataion(_currentLatLng!);
                       Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>  const Definepate(),
                                      ),
                                    );},
                    child: const Text('Add Path')),
              ],
            );
          })
        ],
      ),
      
    );
  }
}

class LocationService {
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, don't continue
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, don't continue
      return false;
    }

    return true;
  }

  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
