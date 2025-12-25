import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onClaimPressed;
  final VoidCallback onTestConnectionPressed;

  const ActionButtons({
    super.key,
    required this.onClaimPressed,
    required this.onTestConnectionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onClaimPressed,
            icon: const Icon(
              Icons.edit_note,
              size: 20,
              color: AppColors.primary,
            ),
            label: const Text(
              'Faire une réclamation',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onTestConnectionPressed,
            icon: const Icon(Icons.wifi_find, size: 20, color: Colors.white),
            label: const Text(
              'Tester ma connexion',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}
