// lib/data/datasources/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_assignment_1/user_model.dart';


class ApiService {
  final String baseUrl = 'https://c43d9c37-22a2-4d9b-9f13-923d980cd6ec.mock.pstmn.io';

  // Get paginated users
  Future<List<UserModel>> getPaginatedUsers(int page) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/users?page=$page'));
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> usersJson = jsonData['users'] ?? []; // Changed from 'data' to 'users'
      
      return usersJson.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to fetch users: $e');
  }
}
  // Get user by ID
  Future<UserModel> getUserById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/$id'));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return UserModel.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to load user details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }

  // Add a new user (mock)
  Future<UserModel> addUser(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return UserModel.fromJson(jsonData['data'] ?? user.toJson());
      } else {
        throw Exception('Failed to add user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  // Update user (mock)
  Future<UserModel> updateUser(int id, UserModel user) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return UserModel.fromJson(jsonData['data'] ?? user.toJson());
      } else {
        throw Exception('Failed to update user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
}