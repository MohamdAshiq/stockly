import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SearchErrorStateWidget extends StatelessWidget {
  final String message;

  const SearchErrorStateWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.negativeBadgeBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.negativePrice.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: AppColors.negativePrice,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
