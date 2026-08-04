import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/domain/entities/stock_entity.dart';
import '../../../home/presentation/pages/stock_detail_page.dart';

class WatchlistCardWidget extends StatelessWidget {
  final StockEntity stock;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const WatchlistCardWidget({
    super.key,
    required this.stock,
    required this.onDelete,
    this.onTap,
  });

  List<Color> _getGradientForSymbol(String symbol) {
    final index = symbol.hashCode.abs() % AppColors.avatarGradients.length;
    return AppColors.avatarGradients[index];
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _getGradientForSymbol(stock.symbol);
    final isNegative = stock.changePercent.contains('-');
    final initialChar = stock.symbol.isNotEmpty ? stock.symbol[0] : 'S';

    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    StockDetailPage(stock: stock, onToggleSave: onDelete),
              ),
            );
          },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Company Avatar Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    initialChar,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Symbol & Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stock.symbol,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stock.name.isNotEmpty ? stock.name : stock.symbol,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Price & Change Badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    stock.price > 0
                        ? '\$${stock.price.toStringAsFixed(2)}'
                        : 'N/A',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: stock.price > 0
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (stock.price > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isNegative
                            ? AppColors.negativeBadgeBg
                            : AppColors.positiveBadgeBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        stock.changePercent,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isNegative
                              ? AppColors.negativePrice
                              : AppColors.positivePrice,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 8),

              // Delete Action Button
              IconButton(
                splashRadius: 22,
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.deleteRed,
                  size: 22,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
