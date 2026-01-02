import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/notification_entity.dart';
import '../../presentation/screens/app_shell.dart';
import '../../presentation/screens/login_phone_screen.dart';
import '../../presentation/screens/otp_verification_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/order_details_screen.dart';
import '../../presentation/screens/claim_screen.dart';
import '../../presentation/screens/claims_history_screen.dart';
import '../../presentation/screens/notification_detail_screen.dart';
import '../../presentation/screens/technician_location_screen.dart';
import '../../presentation/viewmodels/auth_viewmodel.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String otpVerification = '/otp-verification';
  static const String home = '/';
  static const String settings = '/settings';
  static const String orderDetails = '/order-details';
  static const String claim = '/claim';
  static const String claimsHistory = '/claims-history';
  static const String notificationDetail = '/notification-detail';
  static const String technicianLocation = '/technician-location';

  static GoRouter router(Ref ref) {
    return GoRouter(
      initialLocation: splash,
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final authState = ref.read(authProvider);
        final isCheckingSession = authState.isCheckingSession;
        final isLoggedIn = authState.isLoggedIn;
        final currentPath = state.uri.path;

        if (isCheckingSession) {
          if (currentPath != splash) {
            return splash;
          }
          return null;
        }

        if (isLoggedIn) {
          if (currentPath == login ||
              currentPath == otpVerification ||
              currentPath == splash) {
            return home;
          }
        }

        if (!isLoggedIn) {
          if (currentPath != login &&
              currentPath != otpVerification &&
              currentPath != splash) {
            return login;
          }
          if (currentPath == splash) {
            return login;
          }
        }

        return null;
      },
      routes: [
        GoRoute(
          path: splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: login,
          name: 'login',
          builder: (context, state) => const LoginPhoneScreen(),
        ),
        GoRoute(
          path: otpVerification,
          name: 'otp-verification',
          builder: (context, state) => const OtpVerificationScreen(),
        ),
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const AppShell(),
        ),
       
        GoRoute(
          path: orderDetails,
          name: 'order-details',
          builder: (context, state) {
            final order = state.extra as OrderEntity;
            return OrderDetailsScreen(order: order);
          },
        ),
        GoRoute(
          path: claim,
          name: 'claim',
          builder: (context, state) {
            final orderReference = state.extra as String;
            return ClaimScreen(orderReference: orderReference);
          },
        ),
        GoRoute(
          path: claimsHistory,
          name: 'claims-history',
          builder: (context, state) => const ClaimsHistoryScreen(),
        ),
        GoRoute(
          path: notificationDetail,
          name: 'notification-detail',
          builder: (context, state) {
            final notification = state.extra as NotificationEntity;
            return NotificationDetailScreen(notification: notification);
          },
        ),
        GoRoute(
          path: technicianLocation,
          name: 'technician-location',
          builder: (context, state) {
            final orderReference = state.extra as String;
            return TechnicianLocationScreen(orderReference: orderReference);
          },
        ),
      ],
      errorBuilder:
          (context, state) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Page not found',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The page ${state.uri.path} does not exist.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go(home),
                    child: const Text('Go Home'),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.router(ref);
});
