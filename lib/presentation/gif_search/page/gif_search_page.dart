import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_assignment/presentation/gif_search/bloc/gif_bloc.dart';
import 'package:giphy_assignment/presentation/gif_search/bloc/gif_event.dart';
import 'package:giphy_assignment/presentation/gif_search/bloc/gif_state.dart';
import 'package:giphy_assignment/presentation/gif_search/widget/gif_tile.dart';

class GifSearchPage extends StatefulWidget {
  const GifSearchPage({super.key});

  @override
  State<GifSearchPage> createState() => _GifSearchPageState();
}

class _GifSearchPageState extends State<GifSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200) {
      context.read<GifBloc>().add(GifLoadMoreGif());
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {

      if (value.trim().isEmpty) {
        context.read<GifBloc>().add(GifCall());
        return;
      }

      context.read<GifBloc>().add(GifSearchQueryChanged(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GIF Finder'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 4),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search GIFs...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged("");
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<GifBloc, GifState>(
              builder: (context, state) {
                if (state.status == GifStatus.loading && state.gifs.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == GifStatus.failure && state.gifs.isEmpty) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? 'Something went wrong',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (state.gifs.isEmpty) {
                  return const Center(
                    child: Text('No GIFs found'),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: state.gifs.length,
                        itemBuilder: (context, index) {
                          final gif = state.gifs[index];
                          return GifTile(gif: gif);
                        },
                      ),
                    ),
                    if (state.status == GifStatus.loading && state.gifs.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: CircularProgressIndicator(),
                      ),

                    if (state.hasReachedMax)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text("No more results"),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}