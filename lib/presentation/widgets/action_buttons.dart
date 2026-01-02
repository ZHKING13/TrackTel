import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
            icon:  Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(1),
    
      child: SvgPicture.asset("assets/Icones/home/support.svg"),
    ),
            label: const Text(
              'Faire une réclamation',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.textSecondary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onTestConnectionPressed,
            icon:  SizedBox(
              width: 24,
              height: 24,

              child: SvgPicture.asset("assets/Icones/technicien/test.svg"),
            ),
            label: const Text(
              'Tester ma connexion',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}
