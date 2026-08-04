import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/stock_entity.dart';

class StockDetailHeaderWidget extends StatelessWidget {
  final StockEntity stock;

  const StockDetailHeaderWidget({super.key, required this.stock});

  List<Color> _getGradientForSymbol(String symbol) {
    final index = symbol.hashCode.abs() % AppColors.avatarGradients.length;
    return AppColors.avatarGradients[index];
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _getGradientForSymbol(stock.symbol);
    final initialChar = stock.symbol.isNotEmpty ? stock.symbol[0] : 'S';

    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              initialChar,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stock.name.isNotEmpty ? stock.name : stock.symbol,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${stock.region.isNotEmpty ? stock.region : "Global"} • ${stock.type.isNotEmpty ? stock.type : "Equity"}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
