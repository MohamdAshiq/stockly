import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/database/hive_service.dart';
import '../../../../core/network/api_client.dart';
import '../../../watchlist/data/datasources/watchlist_local_data_source.dart';
import '../../data/datasources/stock_remote_data_source.dart';
import '../../data/repositories/stock_repository_impl.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/search_error_state_widget.dart';
import '../widgets/search_initial_state_widget.dart';
import '../widgets/stock_card_widget.dart';
import '../widgets/stock_skeleton_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final apiClient = ApiClient();
        final remoteDataSource = StockRemoteDataSourceImpl(
          apiClient: apiClient,
        );
        final hiveService = HiveService();
        final localDataSource = WatchlistLocalDataSourceImpl(
          hiveService: hiveService,
        );
        final repository = StockRepositoryImpl(
          remoteDataSource: remoteDataSource,
          localDataSource: localDataSource,
        );
        return SearchBloc(repository: repository);
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  // Search Bar Widget
                  SearchBarWidget(
                    controller: _controller,
                    onChanged: (query) {
                      context.read<SearchBloc>().add(
                        SearchQueryChangedEvent(query),
                      );
                    },
                    onClear: () {
                      context.read<SearchBloc>().add(
                        const SearchQueryChangedEvent(''),
                      );
                    },
                  ),

                  Expanded(
                    child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        // Initial State
                        if (state is SearchInitialState) {
                          return const SearchInitialStateWidget();
                        }
                        // Loading State
                        if (state is SearchLoadingState) {
                          return const StockSkeletonWidget();
                        }
                        // Empty State
                        if (state is SearchEmptyState) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 48,
                                  color: AppColors.textMuted,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'No matching stocks found',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        // Error State
                        if (state is SearchErrorState) {
                          return SearchErrorStateWidget(message: state.message);
                        }

                        if (state is SearchLoadedState) {
                          return ListView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: state.stocks.length,
                            itemBuilder: (context, index) {
                              final stock = state.stocks[index];
                              return StockCardWidget(
                                stock: stock,
                                onToggleSave: () {
                                  context.read<SearchBloc>().add(
                                    ToggleSaveStockEvent(stock),
                                  );
                                },
                              );
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
