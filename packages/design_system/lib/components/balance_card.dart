import 'package:flutter/material.dart';

import '../tokens/yellow_colors.dart';
import '../tokens/yellow_shadows.dart';
import '../tokens/yellow_spacing.dart';
import '../tokens/yellow_typography.dart';
import 'category_badge.dart';

/// Card Estudantil com destaque para o saldo atual.
class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balanceText,
    required this.holderName,
    required this.statusLabel,
    required this.cardTypeLabel,
    this.cardNumber = '',
    this.isActive = true,
    this.onTap,
  });

  final String balanceText;
  final String holderName;
  final String statusLabel;
  final String cardTypeLabel;
  final String cardNumber;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(YellowSpacing.radiusXl),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [YellowColors.blue900, YellowColors.blue700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(YellowSpacing.radiusXl),
            boxShadow: YellowShadows.lg,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(YellowSpacing.radiusXl),
            child: Stack(
              children: [
                Positioned(
                  right: -40,
                  top: -40,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: YellowColors.yellow500.withValues(alpha: 0.9),
                    ),
                  ),
                ),
                Positioned(
                  right: 30,
                  top: 60,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: YellowColors.orange500.withValues(alpha: 0.85),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(YellowSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.directions_bus_rounded,
                              color: YellowColors.neutral0, size: 22),
                          const SizedBox(width: YellowSpacing.sm),
                          Text('Cartão $cardTypeLabel',
                              style: YellowTypography.bodyBold
                                  .copyWith(color: YellowColors.neutral0)),
                        ],
                      ),
                      const SizedBox(height: YellowSpacing.lg),
                      Text('Saldo atual',
                          style: YellowTypography.body.copyWith(
                              color: YellowColors.neutral0
                                  .withValues(alpha: 0.75))),
                      const SizedBox(height: YellowSpacing.xs),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(balanceText,
                            style: YellowTypography.display
                                .copyWith(color: YellowColors.neutral0)),
                      ),
                      const SizedBox(height: YellowSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              holderName.isEmpty
                                  ? (cardNumber.isEmpty ? 'Estudante' : cardNumber)
                                  : holderName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: YellowTypography.bodyBold
                                  .copyWith(color: YellowColors.neutral0),
                            ),
                          ),
                          const SizedBox(width: YellowSpacing.sm),
                          CategoryBadge(
                            label: statusLabel,
                            tone: isActive ? BadgeTone.success : BadgeTone.danger,
                            icon: isActive
                                ? Icons.check_circle_rounded
                                : Icons.block_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
