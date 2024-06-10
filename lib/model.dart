import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:chatview/chatview.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class Model extends ChangeNotifier {
  String? _token;
  String? _userId;

  String? get token => _token;
  String? get userId => _userId;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  bool? _obscureasignup = true;
  bool? get obscure => _obscureasignup;

  void changeobscure() {
    _obscureasignup = !_obscureasignup!;
    notifyListeners();
  }

  bool errorverify = false;

  void errorverifyfun() {
    errorverify = true;
    notifyListeners();
  }

  bool? _obscurealogin = true;
  bool? get obscurelogin => _obscurealogin;

  void changeobscurelogin() {
    _obscurealogin = !_obscurealogin!;
    notifyListeners();
  }

  final List<Message> _messages = [];
  List<Message> get messages => _messages;

  final ChatUser _user = ChatUser(id: 'user_id', name: 'Me');
  final ChatUser _bella = ChatUser(id: 'bella_id', name: 'Bella Alex');

  void sendMessage(String text) {
    if (text.isNotEmpty) {
      final message = Message(
        id: const Uuid().v4(),
        message: text,
        createdAt: DateTime.now(),
        sendBy: _user.id,
        status: MessageStatus.pending,
      );
      _messages.add(message);
      notifyListeners();
      _simulateReply();
    }
  }

  void _simulateReply() {
    Future.delayed(const Duration(seconds: 1), () {
      final reply = Message(
        id: const Uuid().v4(),
        message: "Got it, I am on my way!",
        createdAt: DateTime.now(),
        sendBy: _bella.id,
        status: MessageStatus.delivered,
      );
      _messages.add(reply);
      notifyListeners();
    });
  }

  ChatUser get currentUser => _user;

  LatLng? _locataion;
  LatLng? _startLatLng;
  LatLng? _endLatLng;
  List<LatLng> _polylinePoints = [];
  DateTime? _selectedDateTime;
  String? _startAddress;
  String? _endAddress;
  double? _distance;
  String? _city;

  LatLng? get location => _locataion;
  LatLng? get startLatLng => _startLatLng;
  LatLng? get endLatLng => _endLatLng;
  List<LatLng> get polylinePoints => _polylinePoints;
  DateTime? get selectedDateTime => _selectedDateTime;
  String? get startAddress => _startAddress;
  String? get endAddress => _endAddress;
  double? get distance => _distance;
  String? get city => _city;

  void setlocataion(LatLng locataion) {
    _locataion = locataion;
    notifyListeners();
  }

  Future<void> getMap(LatLng? startLatLng, LatLng? endLatLng,
      DateTime? selectedDateTime, List<LatLng> polylinePoints) async {
    _polylinePoints = polylinePoints;
    _startLatLng = startLatLng;
    _endLatLng = endLatLng;
    _selectedDateTime = selectedDateTime;

    if (startLatLng != null) {
      _startAddress = await _getAddressFromLatLng(startLatLng);
    }
    if (endLatLng != null) {
      _endAddress = await _getAddressFromLatLng(endLatLng);
    }

    notifyListeners();
  }

  Future<void> fetchRoute(String apiKey) async {
    if (_startLatLng != null && _endLatLng != null) {
      final url =
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${_startLatLng!.longitude},${_startLatLng!.latitude}&end=${_endLatLng!.longitude},${_endLatLng!.latitude}';

      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data == null ||
              data['features'] == null ||
              data['features'].isEmpty) {
            throw Exception('Invalid route data received.');
          }

          final route = data['features'][0];
          final distanceMeters = route['properties']['segments'][0]['distance'];
          final geometry = route['geometry']['coordinates'];
          final coordinates = _decodePolyline(geometry);

          _distance = distanceMeters / 1000; // convert to kilometers
          _polylinePoints = coordinates
              .map<LatLng>((point) => LatLng(point[1], point[0]))
              .toList();

          notifyListeners();
        } else {
          throw Exception('Failed to load route: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Failed to load route: $e');
      }
    }
  }

  List<List<double>> _decodePolyline(List<dynamic> encoded) {
    return encoded.map<List<double>>((point) {
      return [point[0].toDouble(), point[1].toDouble()];
    }).toList();
  }

  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isEmpty) {
        log("Placemark list is empty.");
        return "No Address";
      }

      var combinedAddress = "";
      if (placemarks.length > 1) {
        Placemark secondPlacemark = placemarks[1];
        var street = secondPlacemark.street!;
        combinedAddress =
            "$street ${secondPlacemark.subThoroughfare} ${secondPlacemark.thoroughfare}";
      }
      for (var placemark in placemarks) {
        if (placemark.street != null &&
            placemark.subThoroughfare != null &&
            placemark.thoroughfare != null) {
          _city = placemark.locality!;
          var street = placemark.street!;
          notifyListeners();
          street =
              "$street ${placemark.subThoroughfare} ${placemark.thoroughfare}";
          combinedAddress = '$street $combinedAddress';

          // Clean up the street name
          var cleanedStreet = cleanStreetName(combinedAddress);

          return cleanedStreet;
        } else {
          log("Placemark street is null for placemark: $placemark");
        }
      }
      log("No valid street found in placemarks.");
      return "No Address";
    } catch (e, stacktrace) {
      log("Error getting placemarks: $e");
      log("Stacktrace: $stacktrace");
      return "No Address";
    }
  }

  String cleanStreetName(String street) {
    // Remove numbers and English letters
    street = street.replaceAll(RegExp(r'[0-9A-Za-z]+'), '');

    // Remove special characters like +, commas, and extra spaces
    street = street
        .replaceAll(RegExp(r'[,+]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    // Split the street into parts
    var parts = street.split(' ');

    // Remove duplicate parts
    var uniqueParts = LinkedHashSet<String>.from(parts).toList();

    // Join the parts back into a single string
    return uniqueParts.join(' ');
  }
int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
