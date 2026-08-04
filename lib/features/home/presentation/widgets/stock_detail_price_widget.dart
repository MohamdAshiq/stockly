import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/stock_entity.dart';

class StockDetailPriceWidget extends StatelessWidget {
  final StockEntity stock;

  const StockDetailPriceWidget({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final isNegative = stock.changePercent.contains('-');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          stock.price > 0 ? '\$${stock.price.toStringAsFixed(2)}' : 'N/A',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 12),
        if (stock.price > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isNegative
                  ? AppColors.negativeBadgeBg
                  : AppColors.positiveBadgeBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isNegative
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  size: 14,
                  color: isNegative
                      ? AppColors.negativePrice
                      : AppColors.positivePrice,
                ),
                const SizedBox(width: 4),
                Text(
                  stock.changePercent,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isNegative
                        ? AppColors.negativePrice
                        : AppColors.positivePrice,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
