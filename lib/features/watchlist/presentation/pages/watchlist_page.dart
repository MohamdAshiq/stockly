import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/presentation/widgets/stock_skeleton_widget.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';
import '../widgets/watch_list_empty_state_widget.dart';
import '../widgets/watch_list_header_widget.dart';
import '../widgets/watchlist_card_widget.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistBloc>().add(const LoadWatchlistEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<WatchlistBloc, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistLoadingState) {
              return const StockSkeletonWidget();
            }

            if (state is WatchlistEmptyState) {
              return WatchListEmptyStateWidget();
            }

            if (state is WatchlistErrorState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.negativeBadgeBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      state.message,
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

            if (state is WatchlistLoadedState) {
              final stocks = state.stocks;
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  context.read<WatchlistBloc>().add(
                    const RefreshWatchlistEvent(),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Watchlist Header Count Chip
                    WatchListHeaderWidget(stocks: stocks),

                    Expanded(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: stocks.length,
                        itemBuilder: (context, index) {
                          final stock = stocks[index];
                          return Dismissible(
                            key: Key(stock.symbol),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.deleteRed,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            onDismissed: (_) {
                              context.read<WatchlistBloc>().add(
                                RemoveFromWatchlistEvent(stock.symbol),
                              );
                            },
                            child: WatchlistCardWidget(
                              stock: stock,
                              onDelete: () {
                                context.read<WatchlistBloc>().add(
                                  RemoveFromWatchlistEvent(stock.symbol),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
