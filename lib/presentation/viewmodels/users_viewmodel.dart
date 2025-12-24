import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_users_usecase.dart';

/// Provider for UserRepository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl();
});

/// Provider for GetUsersUseCase
final getUsersUseCaseProvider = Provider<GetUsersUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUsersUseCase(repository);
});

/// State for users list
enum UsersState { initial, loading, loaded, error }

/// Users state notifier
class UsersNotifier extends StateNotifier<AsyncValue<List<UserEntity>>> {
  final GetUsersUseCase _getUsersUseCase;

  UsersNotifier(this._getUsersUseCase) : super(const AsyncValue.loading()) {
    loadUsers();
  }

  /// Load users from repository
  Future<void> loadUsers() async {
    state = const AsyncValue.loading();
    try {
      final users = await _getUsersUseCase();
      state = AsyncValue.data(users);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Refresh users
  Future<void> refresh() async {
    await loadUsers();
  }
}

/// Provider for UsersNotifier
final usersProvider =
    StateNotifierProvider<UsersNotifier, AsyncValue<List<UserEntity>>>((ref) {
      final getUsersUseCase = ref.watch(getUsersUseCaseProvider);
      return UsersNotifier(getUsersUseCase);
    });
