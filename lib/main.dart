import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_assignment/data/repository/gif_repository.dart';
import 'package:giphy_assignment/data/sources/api_services.dart';
import 'package:giphy_assignment/domain/usecase/gif_search.dart';
import 'package:giphy_assignment/domain/usecase/gif_trending.dart';
import 'package:giphy_assignment/presentation/gif_search/bloc/gif_bloc.dart';
import 'package:giphy_assignment/presentation/gif_search/bloc/gif_event.dart';
import 'package:giphy_assignment/presentation/gif_search/page/gif_search_page.dart';
import 'package:giphy_assignment/presentation/splash/splash_screen.dart';

void main() {
  final remoteDataSource = GiphyRemoteDataSourceImpl();
  final repository = GifRepositoryImpl(remoteDataSource: remoteDataSource);
  final getTrendingGifs = GetTrendingGifs(repository);
  final searchGifs = GifSearch(repository);
  runApp(MyApp(getTrendingGifs: getTrendingGifs,gifSearch: searchGifs,));
}

class MyApp extends StatelessWidget {
  final GifSearch gifSearch;
  final GetTrendingGifs getTrendingGifs;
  const MyApp({super.key, required this.gifSearch, required this.getTrendingGifs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => GifBloc(gifSearch, getTrendingGifs)..add(GifCall()),
        child: GifSearchPage(),
      ),
    );
  }
}
