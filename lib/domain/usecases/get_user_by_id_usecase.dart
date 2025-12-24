import '../entities/user_entity.dart';
import '../../data/repositories/user_repository.dart';

/// Use case for getting a user by ID
/// Encapsulates the business logic for retrieving a single user
class GetUserByIdUseCase {
  final UserRepository _repository;

  GetUserByIdUseCase(this._repository);

  /// Execute the use case
  Future<UserEntity?> call(String id) async {
    return await _repository.getUserById(id);
  }
}
