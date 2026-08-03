import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/stock_entity.dart';

class StockCardWidget extends StatelessWidget {
  final StockEntity stock;
  final VoidCallback onToggleSave;

  const StockCardWidget({
    super.key,
    required this.stock,
    required this.onToggleSave,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border, width: 0.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          stock.name.isNotEmpty ? stock.name : stock.symbol,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          stock.symbol,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        trailing: Row(
          mainAxisSize: .min,
          children: [
            Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .end,
              children: [
                Text(
                  stock.isPriceLoading
                      ? 'Fetching...'
                      : stock.price > 0
                      ? 'Rs ${stock.price.toStringAsFixed(2)}'
                      : 'N/A',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: stock.price > 0
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                if (stock.price > 0)
                  Text(
                    stock.changePercent,
                    style: TextStyle(
                      fontSize: 12,
                      color: stock.changePercent.contains('-')
                          ? AppColors.negativePrice
                          : AppColors.positivePrice,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: Icon(
                stock.isSaved ? Icons.check_circle : Icons.add_circle_outline,
                color: stock.isSaved ? AppColors.secondary : AppColors.primary,
                size: 28,
              ),
              onPressed: onToggleSave,
            ),
          ],
        ),
      ),
    );
  }
}
