import 'package:equatable/equatable.dart';

abstract class GifEvent extends Equatable {
  const GifEvent();

  @override
  List<Object?> get props => [];
}

class GifCall extends GifEvent {}

class GifSearchQueryChanged extends GifEvent {
  final String query;

  const GifSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class GifLoadMoreGif extends GifEvent {}
