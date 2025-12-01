import 'package:giphy_assignment/domain/model/gif_entity.dart';
import 'package:giphy_assignment/domain/repository/gif_repo.dart';

class GetTrendingGifs {
  final GifRepository repository;

  GetTrendingGifs(this.repository);

  Future<List<GifEntity>> call({
    int limit = 25,
    int offset = 0,
  }) {
    return repository.getTrending(limit: limit, offset: offset);
  }
}
