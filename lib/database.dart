
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tomnia/model.dart';  // Adjust this import based on your project structure

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



