import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../viewmodels/navigation_viewmodel.dart';
import '../viewmodels/notifications_viewmodel.dart';
import 'dashboard_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  Widget _buildNotificationIcon(WidgetRef ref, bool isActive) {
    final notificationsState = ref.watch(notificationsProvider);
    final unreadCount = notificationsState.unreadCount;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          'assets/Icones/navbar/Notification.svg',
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            isActive ? AppColors.primary : AppColors.backgroundDark,
            BlendMode.srcIn,
          ),
        ),
        if (unreadCount > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                unreadCount > 99 ? '99+' : unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          DashboardScreen(),
          NotificationScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                ref.read(navigationProvider.notifier).setTab(index);
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.backgroundDark,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/Icones/navbar/Home.svg',
                    width: 24,
                    height: 24,
                   
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/Icones/navbar/Home.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Accueil',
                ),
                BottomNavigationBarItem(
                  icon: _buildNotificationIcon(ref, false),
                  activeIcon: _buildNotificationIcon(ref, true),
                  label: 'Notification',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/Icones/navbar/user.svg',
                    width: 24,
                    height: 24,
                   
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/Icones/navbar/user.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
