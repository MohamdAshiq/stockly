import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/domain/entities/stock_entity.dart';

class WatchListHeaderWidget extends StatelessWidget {
  const WatchListHeaderWidget({super.key, required this.stocks});

  final List<StockEntity> stocks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${stocks.length} ${stocks.length == 1 ? 'Saved Stock' : 'Saved Stocks'}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Pull to refresh',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
