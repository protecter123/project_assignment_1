// lib/domain/repositories/user_repository.dart

import 'package:project_assignment_1/user_model.dart';



abstract class UserRepository {
  Future<List<UserModel>> getPaginatedUsers(int page);
  Future<UserModel> getUserById(int id);
  Future<UserModel> addUser(UserModel user);
  Future<UserModel> updateUser(int id, UserModel user);
  Future<List<UserModel>> searchUsers(String query);
}