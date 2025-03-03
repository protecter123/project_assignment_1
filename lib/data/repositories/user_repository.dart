// lib/data/repositories/user_repository_impl.dart

import 'package:project_assignment_1/data/datasources/api_service.dart';
import 'package:project_assignment_1/data/datasources/local_Storage.dart';
import 'package:project_assignment_1/data/models/user_model.dart';
import 'package:project_assignment_1/data/repositories/user_repository_interface.dart';


class UserRepositoryImpl implements UserRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;

  UserRepositoryImpl({
    required this.apiService,
    required this.localStorageService,
  });

  @override
  Future<List<UserModel>> getPaginatedUsers(int page) async {
    try {
      // First try to get from API
      final users = await apiService.getPaginatedUsers(page);
      
      // If successful, save to local storage
      if (users.isNotEmpty) {
        // Only save the first page to local storage
        if (page == 1) {
          await localStorageService.saveUsers(users);
        }
      }
      
      // Get locally added users
      final localUsers = await localStorageService.getUsers();
      final apiUserIds = users.map((u) => u.id).toSet();
      
      // Filter out local users that are not in the API response
      final localOnlyUsers = localUsers.where((user) => !apiUserIds.contains(user.id)).toList();
      
      // Combine API users with locally added users
      return [...users, ...localOnlyUsers];
    } catch (e) {
      // If API fails, try to get from local storage
      return localStorageService.getUsers();
    }
  }

  @override
  Future<UserModel> getUserById(int id) async {
    try {
      // First check if user exists locally
      final localUser = await localStorageService.getUserById(id);
      
      if (localUser != null) {
        return localUser;
      }
      
      // If not found locally, get from API
      final user = await apiService.getUserById(id);
      
      // Save to local storage
      await localStorageService.saveUser(user);
      
      return user;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<UserModel> addUser(UserModel user) async {
    try {
      // Get a new ID
      final newId = await localStorageService.getNextId();
      
      // Create user with new ID
      final newUser = user.copyWith(id: newId);
      
      // Save to local storage
      await localStorageService.saveUser(newUser);
      
      // Also try to add to API (this would be just for simulation)
      try {
        await apiService.addUser(newUser);
      } catch (_) {
        // Ignore API errors as we're using local storage as source of truth
      }
      
      return newUser;
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  @override
  Future<UserModel> updateUser(int id, UserModel user) async {
    try {
      // Update user locally
      await localStorageService.saveUser(user);
      
      // Also try to update on API (this would be just for simulation)
      try {
        await apiService.updateUser(id, user);
      } catch (_) {
        // Ignore API errors as we're using local storage as source of truth
      }
      
      return user;
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final allUsers = await localStorageService.getUsers();
      
      // Filter users based on search query
      return allUsers.where((user) {
        final name = user.name.toLowerCase();
        final email = user.email.toLowerCase();
        final searchLower = query.toLowerCase();
        
        return name.contains(searchLower) || email.contains(searchLower);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }
}