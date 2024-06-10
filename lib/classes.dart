import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';


// user calss

// cashing shared preferences for user
class SharedPreferencesHelper {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<bool> getSeen() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('seen') ?? false;
  }

  static Future<String> getUserType() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('userType') ?? 'passenger';
  }

  static Future<void> setSeen(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('seen', value);
  }

  static Future<void> setUserType(String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('userType', value);
  }
}



class User {
  final String id;
  final String name;

  const User({
    required this.id,
    required this.name,
    String? avatar,
  });
}

class ApiService {
  final String baseUrl = 'https://localhost:7174/api';

  Future<String> getSampleData() async {
    final response = await http.get(Uri.parse('$baseUrl/sample'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['message'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> postSampleData(String name, int value) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sample'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'value': value,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['message'];
    } else {
      throw Exception('Failed to post data');
    }
  }
}

class MessageService {
  final String baseUrl;

  MessageService(this.baseUrl);

  Future<http.Response> getMessages() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Message/get'),
    );
    return response;
  }

  Future<http.Response> sendMessage(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Message/send'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
