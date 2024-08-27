import 'package:http/http.dart' as http;

import 'dart:convert';

class Ride {
  final String rideId;
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime startTime;
  final DateTime endTime;
  final int rider;
  final double fare;
  final DateTime requestTime;
  final String vehicleId;
  final String passengerId;

  Ride({
    required this.rideId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.startTime,
    required this.endTime,
    required this.rider,
    required this.fare,
    required this.requestTime,
    required this.vehicleId,
    required this.passengerId,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      rideId: json['rideId'],
      pickupLocation: json['pickupLocation'],
      dropoffLocation: json['dropoffLocation'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      rider: json['rider'],
      fare: json['fare'].toDouble(),
      requestTime: DateTime.parse(json['requestTime']),
      vehicleId: json['vehicleId'],
      passengerId: json['passengerId'],
    );
  }
}


class ApiResponselogin {
  final bool success;
  final String? token;
  final String? expiration;
  final int errorType;

  ApiResponselogin({
    required this.success,
    this.token,
    this.expiration,
    required this.errorType,
  });

  factory ApiResponselogin.fromJson(Map<String, dynamic> json) {
    return ApiResponselogin(
      success: json['success'],
      token: json['token'] as String?,
      expiration: json['expiration'] as String?,
      errorType: json['errorType'],
    );
  }
}

class ApiResponse {
  final bool success;
  final String? token;
  final String? message;
  final bool emailConfirmationRequired;

  ApiResponse({required this.success, this.token, this.message, this.emailConfirmationRequired = false});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'],
      token: json['token'],
      message: json['message'],
      emailConfirmationRequired: json['emailConfirmationRequired'] ?? false,
    );
  }
}



Future<User?> fetchCurrentUser(String token) async {
  final url = Uri.parse('http://tomnaia.runasp.net/api/User/get-Current-user');
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
      return User.fromJson(json);
    } else {
      throw Exception('Invalid response format');
    }
  } else {
    throw Exception('Failed to fetch user: ${response.reasonPhrase}');
  }
}

class User {
  final String id;
  final String name;
  final String profilePicture;
  final String firstName;
  final String lastName;

  User({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      profilePicture: json['profilePicture'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}
