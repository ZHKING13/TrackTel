import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';

class BoxStatusData {
  final String label;

  final String value;

  final String iconPath;

  final Color? iconColor;

  final bool showStatusDot;

  final Color? statusDotColor;

  const BoxStatusData({
    required this.label,
    required this.value,
    required this.iconPath,
    this.iconColor,
    this.showStatusDot = false,
    this.statusDotColor,
  });
}

class BoxStatusCards extends StatelessWidget {
  final List<BoxStatusData> cards;

  final void Function(int index)? onCardTap;

  const BoxStatusCards({super.key, required this.cards, this.onCardTap});

  factory BoxStatusCards.initial() {
    return const BoxStatusCards(
      cards: [
        BoxStatusData(
          label: 'Box',
          value: '---',
          iconPath: 'assets/Icones/home/box.svg',
        ),
        BoxStatusData(
          label: 'Internet',
          value: '---',
          iconPath: 'assets/Icones/home/Wifi.svg',
        ),
        BoxStatusData(
          label: 'Dernier test',
          value: '---',
          iconPath: 'assets/Icones/home/Test.svg',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          cards.asMap().entries.map((entry) {
            final index = entry.key;
            final card = entry.value;
            final isLast = index == cards.length - 1;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 8),
                child: _StatusCard(
                  data: card,
                  onTap: onCardTap != null ? () => onCardTap!(index) : null,
                ),
              ),
            );
          }).toList(),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final BoxStatusData data;
  final VoidCallback? onTap;

  const _StatusCard({required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              data.iconPath,
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                data.iconColor ?? AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              data.label,
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (data.showStatusDot) ...[
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: data.statusDotColor ?? const Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (data.statusDotColor ??
                                  const Color(0xFF4CAF50))
                              .withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    data.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
