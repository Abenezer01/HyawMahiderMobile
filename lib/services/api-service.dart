import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class APIService {
  final baseUrl = dotenv.env['API_URL'] ?? 'API_URL not found';

  Future<dynamic> getData(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200) {
      // Return the parsed response data
      return response.body;
    } else {
      // Handle the error case
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<dynamic> postData(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      body: json.encode(data), // Convert to JSON string
      headers: {'Content-Type': 'application/json'}, // Set Content-Type header
    );

    if (response.statusCode == 201) {
      // Return the parsed response data
      return response.body;
    } else {
      // Handle the error case
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  }

  Future<dynamic> updateData(
      String endpoint, String id, Map<String, dynamic> data) async {
    final response =
        await http.put(Uri.parse('$baseUrl/$endpoint/$id'), body: data);

    if (response.statusCode == 200) {
      // Return the parsed response data
      return response.body;
    } else {
      // Handle the error case
      throw Exception('Failed to update data: ${response.statusCode}');
    }
  }

  Future<void> deleteData(String endpoint, String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint/$id'));

    if (response.statusCode != 204) {
      // Handle the error case
      throw Exception('Failed to delete data: ${response.statusCode}');
    }
  }
}
