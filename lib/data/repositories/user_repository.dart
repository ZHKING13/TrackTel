import '../../domain/entities/user_entity.dart';

/// Abstract repository interface for user operations
/// Defines the contract that data sources must implement
abstract class UserRepository {
  /// Get all users
  Future<List<UserEntity>> getUsers();

  /// Get user by ID
  Future<UserEntity?> getUserById(String id);

  /// Create a new user
  Future<UserEntity> createUser(UserEntity user);

  /// Update an existing user
  Future<UserEntity> updateUser(UserEntity user);

  /// Delete a user by ID
  Future<bool> deleteUser(String id);
}
