import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/hive_service.dart';
import '../network/api_client.dart';
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
            appBar: AppBar(title: Text(_titles[_currentIndex])),
            body: IndexedStack(index: _currentIndex, children: _pages),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index == 1) {
                  context.read<WatchlistBloc>().add(const LoadWatchlistEvent());
                }
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: AppStrings.homeTabTitle,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: AppStrings.watchlistTabTitle,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
