// lib/data/datasources/local_storage_service.dart

import 'dart:convert';
import 'package:project_assignment_1/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalStorageService {
  // Keys for SharedPreferences
  static const String USERS_KEY = 'users';
  static const String LAST_ID_KEY = 'last_id';

  // Save all users to local storage
  Future<void> saveUsers(List<UserModel> users) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = users.map((user) => user.toJson()).toList();
      await prefs.setString(USERS_KEY, json.encode(usersJson));
    } catch (e) {
      throw Exception('Failed to save users locally: $e');
    }
  }

  // Get all users from local storage
  Future<List<UserModel>> getUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(USERS_KEY);
      
      if (usersJson == null || usersJson.isEmpty) {
        return [];
      }
      
      final List<dynamic> decodedJson = json.decode(usersJson);
      return decodedJson.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get users from local storage: $e');
    }
  }

  // Save a single user to local storage
  Future<void> saveUser(UserModel user) async {
    try {
      final users = await getUsers();
      
      // Check if user already exists
      final index = users.indexWhere((u) => u.id == user.id);
      
      if (index >= 0) {
        // Update existing user
        users[index] = user;
      } else {
        // Add new user
        users.add(user);
      }
      
      await saveUsers(users);
    } catch (e) {
      throw Exception('Failed to save user locally: $e');
    }
  }

  // Get user by ID from local storage
  Future<UserModel?> getUserById(int id) async {
    try {
      final users = await getUsers();
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get the next ID for a new user
  Future<int> getNextId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastId = prefs.getInt(LAST_ID_KEY) ?? 100; // Starting from 100 to avoid conflicts with API IDs
      await prefs.setInt(LAST_ID_KEY, lastId + 1);
      return lastId + 1;
    } catch (e) {
      throw Exception('Failed to get next ID: $e');
    }
  }
}