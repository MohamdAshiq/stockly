import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/stock_entity.dart';
import '../cubit/stock_detail_cubit.dart';
import '../cubit/stock_detail_state.dart';
import '../widgets/stock_detail_action_button.dart';
import '../widgets/stock_detail_chart_widget.dart';
import '../widgets/stock_detail_header_widget.dart';
import '../widgets/stock_detail_price_widget.dart';
import '../widgets/stock_detail_stats_widget.dart';

class StockDetailPage extends StatelessWidget {
  final StockEntity stock;
  final VoidCallback? onToggleSave;

  const StockDetailPage({super.key, required this.stock, this.onToggleSave});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          StockDetailCubit(stock: stock, onToggleSaveCallback: onToggleSave),
      child: const _StockDetailPageView(),
    );
  }
}

class _StockDetailPageView extends StatelessWidget {
  const _StockDetailPageView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockDetailCubit, StockDetailState>(
      builder: (context, state) {
        final stock = state.stock;
        final isNegative = stock.changePercent.contains('-');
        final isSaved = state.isSaved;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              stock.symbol,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                  color: isSaved ? AppColors.primary : AppColors.textSecondary,
                  size: 24,
                ),
                onPressed: () {
                  context.read<StockDetailCubit>().toggleSave();
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stock Header
                StockDetailHeaderWidget(stock: stock),
                const SizedBox(height: 24),

                // Price Banner
                StockDetailPriceWidget(stock: stock),
                const SizedBox(height: 20),

                // Price Trend Chart Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: StockDetailChartWidget(
                    prices: state.chartPrices,
                    isNegative: isNegative,
                  ),
                ),
                const SizedBox(height: 28),

                // Key Statistics Grid
                StockDetailStatsWidget(stock: stock, isSaved: isSaved),
                const SizedBox(height: 32),

                // Watchlist Action Button
                StockDetailActionButton(
                  isSaved: isSaved,
                  onPressed: () {
                    context.read<StockDetailCubit>().toggleSave();
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
