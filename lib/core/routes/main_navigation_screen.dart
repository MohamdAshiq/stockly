import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/hive_service.dart';
import '../network/api_client.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../../features/home/data/datasources/stock_remote_data_source.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/watchlist/data/datasources/watchlist_local_data_source.dart';
import '../../features/watchlist/data/repositories/watchlist_repository_impl.dart';
import '../../features/watchlist/presentation/bloc/watchlist_bloc.dart';
import '../../features/watchlist/presentation/bloc/watchlist_event.dart';
import '../../features/watchlist/presentation/pages/watchlist_page.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [HomePage(), WatchlistPage()];

  final List<String> _titles = const [
    AppStrings.homeTabTitle,
    AppStrings.watchlistTabTitle,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final hiveService = HiveService();
        final localDataSource = WatchlistLocalDataSourceImpl(
          hiveService: hiveService,
        );
        final remoteDataSource = StockRemoteDataSourceImpl(
          apiClient: ApiClient(),
        );
        final repository = WatchlistRepositoryImpl(
          localDataSource: localDataSource,
          remoteDataSource: remoteDataSource,
        );
        return WatchlistBloc(repository: repository);
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_titles[_currentIndex]),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.positiveBadgeBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        radius: 4,
                        backgroundColor: AppColors.positivePrice,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Live',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.positivePrice,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: IndexedStack(index: _currentIndex, children: _pages),
            bottomNavigationBar: Container(
              height: kBottomNavigationBarHeight + 10,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  if (index == 1) {
                    context.read<WatchlistBloc>().add(
                      const LoadWatchlistEvent(),
                    );
                  }
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.explore_outlined),
                    activeIcon: Icon(Icons.explore_rounded),
                    label: AppStrings.homeTabTitle,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark_outline_rounded),
                    activeIcon: Icon(Icons.bookmark_rounded),
                    label: AppStrings.watchlistTabTitle,
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
