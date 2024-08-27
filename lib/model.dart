
import 'package:flutter/material.dart';
import 'package:tomnia/database.dart';
import 'package:uuid/uuid.dart';
import 'package:chatview/chatview.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class Model extends ChangeNotifier {
  // User-related properties and methods
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser1 => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCurrentUser(String token) async {
    final url = Uri.parse('http://tomnaia.runasp.net/api/User/get-Current-user');

    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json != null && json is Map<String, dynamic>) {
          _currentUser = User.fromJson(json);
        } else {
          _errorMessage = 'Invalid response format';
        }
      } else {
        _errorMessage = 'Failed to fetch user: ${response.reasonPhrase}';
      }
    } catch (e) {
      _errorMessage = 'Failed to fetch user: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Additional properties and methods for other functionalities
  bool driverFormCompleted = false;
  bool carFormCompleted = false;
  int? _accountType;
  int? get accountType => _accountType;

  void setDriverFormCompleted(bool completed) {
    driverFormCompleted = completed;
    notifyListeners();
  }

  void setCarFormCompleted(bool completed) {
    carFormCompleted = completed;
    notifyListeners();
  }

  void setAccountType(int accountType) {
    _accountType = accountType;
    notifyListeners();
  }

  bool get isSubmitEnabled => driverFormCompleted && carFormCompleted;

  String? _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJzZXJvYWxleEB5YWhvby5jb20iLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjFiNjYwYWVlLTBiMmEtNGM1NC04ZGY4LTIzZTgyYzlmMjc3YiIsImp0aSI6IjEzYTY2ODBiLWNiNDgtNGY0Ni05ZmY3LTI0OWFiYmRjMTcwMSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlBhc3NlbmdlciIsImV4cCI6MTcxODE1NjMzMSwiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NzE3NC8iLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo1MTczLyJ9.7a3uBlTsTPcnK3Td_D_N8IRaTpm45X8encAbIPwEMvI';
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
    int _currentIndex = 0;
  
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
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
    final placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final placemark = placemarks.first;
    return '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
  }

  void updateLocation(double lat, double long) async {
    _locataion = LatLng(lat, long);
    final placemarks = await placemarkFromCoordinates(lat, long);
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      _city = place.locality;
    }
    notifyListeners();
  }
}

