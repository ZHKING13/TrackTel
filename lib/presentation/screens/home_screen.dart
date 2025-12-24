import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../viewmodels/users_viewmodel.dart';
import '../widgets/widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRouter.settings),
            tooltip: 'Paramètres',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(usersProvider.notifier).refresh(),
        child: usersAsync.when(
          loading:
              () => const LoadingIndicator(
                message: 'Chargement des utilisateurs...',
              ),
          error:
              (error, _) => ErrorDisplay(
                message: 'Erreur: ${error.toString()}',
                onRetry: () => ref.read(usersProvider.notifier).loadUsers(),
              ),
          data: (users) {
            if (users.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 64,
                      color: theme.colorScheme.onSurface.withAlpha(128),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun utilisateur trouvé',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserCard(
                  user: user,
                  onTap: () {
                    // Navigate to user details (to be implemented)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Utilisateur sélectionné: ${user.name}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new user (to be implemented)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ajouter un utilisateur'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
