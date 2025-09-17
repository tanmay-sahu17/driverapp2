import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL for the backend API (dummy endpoints for now)
  static const String baseUrl = 'https://example.com';
  
  // Headers for all API requests
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Update driver's location to the backend
  static Future<bool> updateLocation({
    required String driverId,
    required String busNumber,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/updateLocation'),
        headers: headers,
        body: jsonEncode({
          'driverId': driverId,
          'busNumber': busNumber,
          'latitude': latitude,
          'longitude': longitude,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating location: $e');
      return false;
    }
  }

  /// Send SOS alert with driver details and location
  static Future<bool> sendSosAlert({
    required String driverId,
    required String busNumber,
    required double latitude,
    required double longitude,
    String? emergencyMessage,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sos/alert'),
        headers: headers,
        body: jsonEncode({
          'driverId': driverId,
          'busNumber': busNumber,
          'latitude': latitude,
          'longitude': longitude,
          'emergencyMessage': emergencyMessage ?? 'Emergency SOS Alert',
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending SOS alert: $e');
      return false;
    }
  }

  /// Get ETA information (mock implementation)
  static Future<Map<String, dynamic>?> getEtaInfo({
    required double currentLatitude,
    required double currentLongitude,
    required String busNumber,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/eta/$busNumber')
            .replace(queryParameters: {
          'lat': currentLatitude.toString(),
          'lng': currentLongitude.toString(),
        }),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching ETA info: $e');
      return null;
    }
  }

  /// Register driver with bus assignment
  static Future<bool> registerDriver({
    required String driverId,
    required String busNumber,
    required String driverName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/drivers/register'),
        headers: headers,
        body: jsonEncode({
          'driverId': driverId,
          'busNumber': busNumber,
          'driverName': driverName,
          'registeredAt': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error registering driver: $e');
      return false;
    }
  }
}