import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/stock_entity.dart';

class StockDetailStatsWidget extends StatelessWidget {
  final StockEntity stock;
  final bool isSaved;

  const StockDetailStatsWidget({
    super.key,
    required this.stock,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    final isNegative = stock.changePercent.contains('-');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Statistics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.3,
          children: [
            _buildStatCard(
              'Current Price',
              stock.price > 0 ? '\$${stock.price.toStringAsFixed(2)}' : 'N/A',
              Icons.attach_money_rounded,
            ),
            _buildStatCard(
              '24h Change',
              stock.changePercent,
              isNegative
                  ? Icons.trending_down_rounded
                  : Icons.trending_up_rounded,
              color: isNegative
                  ? AppColors.negativePrice
                  : AppColors.positivePrice,
            ),
            _buildStatCard(
              'Asset Type',
              stock.type.isNotEmpty ? stock.type : 'Equity',
              Icons.category_outlined,
            ),
            _buildStatCard(
              'Region',
              stock.region.isNotEmpty ? stock.region : 'United States',
              Icons.public_rounded,
            ),
            _buildStatCard(
              'Market Status',
              'Live',
              Icons.sensors_rounded,
              color: AppColors.positivePrice,
            ),
            _buildStatCard(
              'Watchlist',
              isSaved ? 'Saved' : 'Not Saved',
              isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isSaved ? AppColors.primary : AppColors.textMuted,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: color ?? AppColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color ?? AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
