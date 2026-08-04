import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class StockDetailActionButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onPressed;

  const StockDetailActionButton({
    super.key,
    required this.isSaved,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSaved
              ? Colors.redAccent.withValues(alpha: 0.1)
              : AppColors.primary,
          foregroundColor: isSaved ? Colors.redAccent : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(
          isSaved ? Icons.delete_outline_rounded : Icons.bookmark_add_rounded,
        ),
        label: Text(
          isSaved ? 'Remove from Watchlist' : 'Add to Watchlist',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
