import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/database/hive_service.dart';
import '../../../../core/network/api_client.dart';
import '../../../watchlist/data/datasources/watchlist_local_data_source.dart';
import '../../data/datasources/stock_remote_data_source.dart';
import '../../data/repositories/stock_repository_impl.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/search_bar_widget.dart';
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
            body: Column(
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
                      if (state is SearchInitialState) {
                        return const Center(
                          child: Text(
                            AppStrings.emptySearchMessage,
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        );
                      }

                      if (state is SearchLoadingState) {
                        return const StockSkeletonWidget();
                      }

                      if (state is SearchEmptyState) {
                        return const Center(
                          child: Text(
                            'No matching stocks found',
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        );
                      }

                      if (state is SearchErrorState) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              state.message,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      if (state is SearchLoadedState) {
                        return ListView.builder(
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
          );
        },
      ),
    );
  }
}
