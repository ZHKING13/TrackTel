import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tracktel/core/theme/app_colors.dart';
import 'box_status_cards.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;

  final List<String> lines;

  final String selectedLine;

  final ValueChanged<String>? onLineChanged;

  final List<BoxStatusData>? boxStatusCards;

  final void Function(int index)? onCardTap;

  const DashboardHeader({
    super.key,
    required this.userName,
    required this.lines,
    required this.selectedLine,
    this.onLineChanged,
    this.boxStatusCards,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final cards =
        boxStatusCards ??
        [
          const BoxStatusData(
            label: 'Box',
            value: '---',
            iconPath: 'assets/Icones/home/box.svg',
          ),
          const BoxStatusData(
            label: 'Internet',
            value: '---',
            iconPath: 'assets/Icones/home/Wifi.svg',
          ),
          const BoxStatusData(
            label: 'Dernier test',
            value: '---',
            iconPath: 'assets/Icones/home/Test.svg',
          ),
        ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Bienvenue, ',
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              _LineDropdown(
                lines: lines,
                selectedLine: selectedLine,
                onChanged: onLineChanged,
              ),
            ],
          ),
          const SizedBox(height: 16),

          _InternalBoxStatusCards(cards: cards, onCardTap: onCardTap),
        ],
      ),
    );
  }
}

class _InternalBoxStatusCards extends StatelessWidget {
  final List<BoxStatusData> cards;
  final void Function(int index)? onCardTap;

  const _InternalBoxStatusCards({required this.cards, this.onCardTap});

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
                child: _HeaderStatusCard(
                  data: card,
                  onTap: onCardTap != null ? () => onCardTap!(index) : null,
                ),
              ),
            );
          }).toList(),
    );
  }
}

class _HeaderStatusCard extends StatelessWidget {
  final BoxStatusData data;
  final VoidCallback? onTap;

  const _HeaderStatusCard({required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.surface, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  _getIconPathForLabel(data.label),
                  width: 16,
                  height: 16,
                  placeholderBuilder:
                      (context) => const SizedBox(
                        width: 16,
                        height: 16,
                        child: Icon(Icons.error, size: 16, color: Colors.red),
                      ),
                ),
                const SizedBox(width: 4),
                Text(
                  data.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Text(
              textAlign: TextAlign.left,
              data.value,
              style: TextStyle(color: Colors.white, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _getIconPathForLabel(String label) {
    switch (label.toLowerCase()) {
      case 'box':
        return 'assets/Icones/home/box.svg';
      case 'internet':
        return 'assets/Icones/home/Wifi.svg';
      case 'dernier test':
        return 'assets/Icones/home/Test.svg';
      default:
        return 'assets/Icones/home/box.svg';
    }
  }
}

class _LineDropdown extends StatelessWidget {
  final List<String> lines;
  final String selectedLine;
  final ValueChanged<String>? onChanged;

  const _LineDropdown({
    required this.lines,
    required this.selectedLine,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLine,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 20,
          ),
          dropdownColor: Colors.grey[900],
          style: const TextStyle(color: Colors.white, fontSize: 14),
          isDense: true,
          items:
              lines.map((String line) {
                return DropdownMenuItem<String>(
                  value: line,
                  child: Text(
                    line,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null && onChanged != null) {
              onChanged!(newValue);
            }
          },
        ),
      ),
    );
  }
}
