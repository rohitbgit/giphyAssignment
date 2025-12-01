import 'package:bloc/bloc.dart';
import 'package:giphy_assignment/domain/usecase/gif_search.dart';
import 'package:giphy_assignment/domain/usecase/gif_trending.dart';
import 'package:giphy_assignment/presentation/gif_search/bloc/gif_event.dart';
import 'package:giphy_assignment/presentation/gif_search/bloc/gif_state.dart';

class GifBloc extends Bloc<GifEvent, GifState> {
  final GifSearch gifSearch;
  final GetTrendingGifs getTrendingGifs;
  static const int _pageSize = 25;
  GifBloc(this.gifSearch, this.getTrendingGifs) : super(GifState()) {
    on<GifCall>(getGIFData);
    on<GifSearchQueryChanged>(onSearchQueryChanged);
    on<GifLoadMoreGif>(onLoadMoreGifs);
  }

  Future<void> getGIFData(
      GifCall event,
      Emitter<GifState> emit,
      ) async {
    emit(state.copyWith(
      status: GifStatus.loading,
      gifs: [],
      hasReachedMax: false,
      query: '',
    ));

    try {
      final gifs = await getTrendingGifs(limit: _pageSize, offset: 0);
      emit(state.copyWith(
        status: GifStatus.success,
        gifs: gifs,
        hasReachedMax: gifs.length < _pageSize,
        query: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GifStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
  Future<void> onSearchQueryChanged(
      GifSearchQueryChanged event,
      Emitter<GifState> emit,
      ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      add(GifCall());
      return;
    }

    emit(state.copyWith(
      status: GifStatus.loading,
      gifs: [],
      hasReachedMax: false,
      query: query,
    ));

    try {
      final gifs = await gifSearch(
        query: query,
        limit: _pageSize,
        offset: 0,
      );
      emit(state.copyWith(
        status: GifStatus.success,
        gifs: gifs,
        hasReachedMax: gifs.length < _pageSize,
        query: query,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GifStatus.failure,
        errorMessage: e.toString(),
        query: query,
      ));
    }
  }

  Future<void> onLoadMoreGifs(
      GifLoadMoreGif event,
      Emitter<GifState> emit,
      ) async {
    if (state.hasReachedMax || state.status != GifStatus.success) {
      return;
    }

    final currentGifs = List.of(state.gifs);
    final offset = currentGifs.length;
    final query = state.query.trim();

    try {
      final newGifs = query.isEmpty
          ? await getTrendingGifs(limit: _pageSize, offset: offset)
          : await gifSearch(
        query: query,
        limit: _pageSize,
        offset: offset,
      );

      final updated = currentGifs + newGifs;

      emit(state.copyWith(
        gifs: updated,
        hasReachedMax: newGifs.length < _pageSize,
        status: GifStatus.success,
      ));
    } catch (e) {
      print(e.toString());
    }
  }
}
