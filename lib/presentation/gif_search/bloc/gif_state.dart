import 'package:equatable/equatable.dart';
import 'package:giphy_assignment/domain/model/gif_entity.dart';

enum GifStatus { initial, loading, success, failure }

class GifState extends Equatable {
  final GifStatus status;
  final List<GifEntity> gifs;
  final bool hasReachedMax;
  final String query;
  final String? errorMessage;

  const GifState({
    this.status = GifStatus.initial,
    this.gifs = const [],
    this.hasReachedMax = false,
    this.query = '',
    this.errorMessage,
  });

  GifState copyWith({
    GifStatus? status,
    List<GifEntity>? gifs,
    bool? hasReachedMax,
    String? query,
    String? errorMessage,
  }) {
    return GifState(
      status: status ?? this.status,
      gifs: gifs ?? this.gifs,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, gifs, hasReachedMax, query, errorMessage];
}
