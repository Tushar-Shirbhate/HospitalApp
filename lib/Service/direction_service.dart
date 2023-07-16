import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DirectionsService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
  static const String _apiKey = 'AIzaSyAUUIJh6-xmTk71u0GI_9116ez79L9XOGo'; // Replace with your API key

  static Future<String> getDirections(LatLng origin, LatLng destination) async {
    final response = await http.get('$_baseUrl?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_apiKey' as Uri);

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);

      if (decodedData['status'] == 'OK') {
        return decodedData['routes'][0]['overview_polyline']['points'];
      } else {
        throw Exception('Failed to fetch directions');
      }
    } else {
      throw Exception('Failed to fetch directions');
    }
  }
}
