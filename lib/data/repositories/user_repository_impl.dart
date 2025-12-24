import '../../domain/entities/user_entity.dart';
import '../mock/mock_data.dart';
import '../models/user_model.dart';
import 'user_repository.dart';


class UserRepositoryImpl implements UserRepository {
  @override
  Future<List<UserEntity>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.users.map(_modelToEntity).toList();
  }

  @override
  Future<UserEntity?> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final model = MockData.getUserById(id);
    return model != null ? _modelToEntity(model) : null;
  }

  @override
  Future<UserEntity> createUser(UserEntity user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return user;
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return user;
  }

  @override
  Future<bool> deleteUser(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // In a real implementation, this would delete the user from the data source
    return true;
  }

  /// Convert UserModel to UserEntity
  UserEntity _modelToEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      avatarUrl: model.avatarUrl,
      createdAt: model.createdAt,
    );
  }
}
