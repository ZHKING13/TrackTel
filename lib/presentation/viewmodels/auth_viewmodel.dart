import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/send_otp_notification_usecase.dart';
import '../../core/services/notification_service.dart';

class AuthKeys {
  static const String isLoggedIn = 'is_logged_in';
  static const String phoneNumber = 'phone_number';
}

@immutable
class AuthState {
  final String phoneNumber;
  final String? generatedOtp;
  final bool isLoading;
  final String? error;
  final bool isOtpVerified;
  final bool isLoggedIn;
  final bool isCheckingSession;
  final bool justLoggedIn;

  const AuthState({
    this.phoneNumber = '',
    this.generatedOtp,
    this.isLoading = false,
    this.error,
    this.isOtpVerified = false,
    this.isLoggedIn = false,
    this.isCheckingSession = true,
    this.justLoggedIn = false,
  });

  AuthState copyWith({
    String? phoneNumber,
    String? generatedOtp,
    bool? isLoading,
    String? error,
    bool? isOtpVerified,
    bool? isLoggedIn,
    bool? isCheckingSession,
    bool? justLoggedIn,
  }) {
    return AuthState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      generatedOtp: generatedOtp ?? this.generatedOtp,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isCheckingSession: isCheckingSession ?? this.isCheckingSession,
      justLoggedIn: justLoggedIn ?? this.justLoggedIn,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  void resetJustLoggedIn() {
    state = state.copyWith(justLoggedIn: false);
  }

  final SendOtpNotificationUseCase _sendOtpNotificationUseCase;

  AuthNotifier(this._sendOtpNotificationUseCase) : super(const AuthState()) {
    checkSession();
  }

  Future<void> checkSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(AuthKeys.isLoggedIn) ?? false;
      final savedPhone = prefs.getString(AuthKeys.phoneNumber) ?? '';

      if (isLoggedIn && savedPhone.isNotEmpty) {
        state = state.copyWith(
          isLoggedIn: true,
          isOtpVerified: true,
          phoneNumber: savedPhone,
          isCheckingSession: false,
        );
        debugPrint('═══════════════════════════════════');
        debugPrint(' Session restaurée pour: $savedPhone');
        debugPrint('═══════════════════════════════════');
      } else {
        state = state.copyWith(isCheckingSession: false);
      }
    } catch (e) {
      debugPrint('Erreur lors de la vérification de session: $e');
      state = state.copyWith(isCheckingSession: false);
    }
  }

  Future<void> _saveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AuthKeys.isLoggedIn, true);
      await prefs.setString(AuthKeys.phoneNumber, state.phoneNumber);
      debugPrint('Session sauvegardée pour: ${state.phoneNumber}');
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde de session: $e');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AuthKeys.isLoggedIn);
      await prefs.remove(AuthKeys.phoneNumber);
      state = const AuthState(isCheckingSession: false);
      debugPrint('═══════════════════════════════════');
      debugPrint(' Déconnexion effectuée');
      debugPrint('═══════════════════════════════════');
    } catch (e) {
      debugPrint('Erreur lors de la déconnexion: $e');
    }
  }

  void setPhoneNumber(String phone) {
    state = state.copyWith(phoneNumber: phone, error: null);
  }

  Future<void> generateOtp() async {
    final random = Random();
    final otp = (1000 + random.nextInt(9000)).toString();
    state = state.copyWith(generatedOtp: otp);

    debugPrint('═══════════════════════════════════');
    debugPrint(' OTP généré: $otp');
    debugPrint(' Numéro: ${state.phoneNumber}');
    debugPrint('═══════════════════════════════════');

    try {
      await _sendOtpNotificationUseCase(
        phoneNumber: state.phoneNumber,
        otp: otp,
      );
      debugPrint('Notification OTP envoyée');
    } catch (e) {
      debugPrint(' Erreur envoi notification OTP: $e');
    }
  }

  Future<bool> verifyOtp(String enteredOtp) async {
    if (state.generatedOtp == null) {
      state = state.copyWith(error: 'Aucun OTP généré');
      return false;
    }

    if (enteredOtp == state.generatedOtp) {
      state = state.copyWith(
        isOtpVerified: true,
        isLoggedIn: true,
        error: null,
        justLoggedIn: true,
      );

      await _saveSession();
      return true;
    } else {
      state = state.copyWith(error: 'Code OTP incorrect');
      return false;
    }
    void resetJustLoggedIn() {
      state = state.copyWith(justLoggedIn: false);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const AuthState(isCheckingSession: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  final sendOtpUseCase = SendOtpNotificationUseCase(notificationService);
  return AuthNotifier(sendOtpUseCase);
});

final isPhoneValidProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.phoneNumber.trim().isNotEmpty &&
      authState.phoneNumber.length == 10;
});

final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isLoggedIn;
});

final isCheckingSessionProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isCheckingSession;
});
