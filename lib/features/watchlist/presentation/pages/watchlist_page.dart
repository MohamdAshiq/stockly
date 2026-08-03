import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../home/presentation/widgets/stock_skeleton_widget.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';
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
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoadingState) {
            return const StockSkeletonWidget();
          }

          if (state is WatchlistEmptyState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<WatchlistBloc>().add(const LoadWatchlistEvent());
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_outline,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      AppStrings.emptyWatchlistMessage,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is WatchlistErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is WatchlistLoadedState) {
            final stocks = state.stocks;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<WatchlistBloc>().add(
                  const RefreshWatchlistEvent(),
                );
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: stocks.length,
                itemBuilder: (context, index) {
                  final stock = stocks[index];
                  return Dismissible(
                    key: Key(stock.symbol),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.redAccent,
                      child: const Icon(Icons.delete, color: Colors.white),
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
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
