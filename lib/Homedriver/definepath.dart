// ignore_for_file: use_build_context_synchronously

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tomnia/Homedriver/ridedetails.dart';
import 'package:tomnia/model.dart';

class Definepate extends StatefulWidget {
  const Definepate({super.key});

  @override
  State<Definepate> createState() => _DefinepateState();
}

class _DefinepateState extends State<Definepate> {
  LatLng? _startLatLng;
  LatLng? _endLatLng;
  List<LatLng> _polylinePoints = [];
  double _distance = 0.0;
  final TextEditingController _costController = TextEditingController();
  DateTime? _selectedDateTime;
  final String _openRouteServiceApiKey =
      '5b3ce3597851110001cf62480a8871e67c6b4182ac87031af4230b75';

Future<void> _selectDateTime(BuildContext context) async {
      final DateTime? picked = await showDatePicker(

      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
    

      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _onTap(TapPosition position, LatLng latlng) {
    setState(() {
      if (_startLatLng == null) {
        _startLatLng = latlng;
      } else if (_endLatLng == null) {
        _endLatLng = latlng;
        _fetchRoute();
      } else {
        _startLatLng = latlng;
        _endLatLng = null;
        _polylinePoints.clear();
        _distance = 0.0;
        _costController.clear();
        _selectedDateTime = null;
      }
    });
  }

  Future<void> _fetchRoute() async {
    if (_startLatLng != null && _endLatLng != null) {
      final url =
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$_openRouteServiceApiKey&start=${_startLatLng!.longitude},${_startLatLng!.latitude}&end=${_endLatLng!.longitude},${_endLatLng!.latitude}';

      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data == null ||
              data['features'] == null ||
              data['features'].isEmpty) {
            _showErrorDialog('Invalid route data received.');
            return;
          }

          final route = data['features'][0];
          final distanceMeters = route['properties']['segments'][0]['distance'];
          final geometry = route['geometry']['coordinates'];
          final coordinates = _decodePolyline(geometry);

       
          setState(() {
            _distance = distanceMeters / 1000; // convert to kilometers
            _polylinePoints = coordinates
                .map<LatLng>((point) => LatLng(point[1], point[0]))
                .toList();
          });
        } else {
          _showErrorDialog('Failed to load route: ${response.statusCode}');
        }
      } catch (e) {
        _showErrorDialog('Failed to load route: $e');
      }
    }
  }

  List<List<double>> _decodePolyline(List<dynamic> encoded) {
    return encoded.map<List<double>>((point) {
      return [point[0].toDouble(), point[1].toDouble()];
    }).toList();
  }



  
  void _showErrorDialog(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        letIndexChange: (index) => true,
      ),
      appBar: AppBar(
        title: const Text('Tomnaia'),
      ),
      body: Stack(
        children: [
          
          Consumer<Model>(builder: (context, model, child) {
            return FlutterMap(
              options: MapOptions(
                initialCenter: model.location!, // Example center
                initialZoom: 15.0,
                onTap: _onTap,
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
                            point: model.location!,
                            child: Image.asset(
                              'images/sedan.png',
                              width: 40,
                              height: 40,
                            )),
                      ],
                    ),
                if (_startLatLng != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _startLatLng!,
                        child: const Icon(Icons.location_on,
                            color: Colors.green, size: 40),
                      ),
                    ],
                  ),
                if (_endLatLng != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _endLatLng!,
                        child: const Icon(Icons.location_on,
                            color: Colors.red, size: 40),
                      ),
                    ],
                  ),
                if (_polylinePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _polylinePoints,
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
              ],);
          }
          ),
          if (_startLatLng != null && _endLatLng != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                padding: const EdgeInsets.all(10.0),
             
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Distance: ${_distance.toStringAsFixed(2)} km',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _costController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Cost (\$)',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDateTime == null
                                ? 'Schedule: Not set'
                                : 'Schedule: ${DateFormat('yyyy/MM/dd HH:mm').format(_selectedDateTime!)}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectDateTime(context),
                          child: const Text('Set Date'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {  Provider.of<Model>(context, listen: false).getMap(_startLatLng, _endLatLng, _selectedDateTime,_polylinePoints);
    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>  const RideDetailsScreen(),
                                      ),
                                    );
                      },
                      child: const Text('Schedule'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    
    );
  }
}

class Distance {
  static const double earthRadius = 6371.0;

  double as(LengthUnit unit, LatLng start, LatLng end) {
    final double dLat = _radians(end.latitude - start.latitude);
    final double dLng = _radians(end.longitude - start.longitude);
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_radians(start.latitude)) *
            cos(_radians(end.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadius * c;
    return distance;
  }

  double _radians(double degree) {
    return degree * pi / 180;
  }
}

enum LengthUnit { kilometer, mile }
