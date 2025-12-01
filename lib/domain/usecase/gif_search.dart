import 'package:giphy_assignment/domain/model/gif_entity.dart';
import 'package:giphy_assignment/domain/repository/gif_repo.dart';

class GifSearch {
  final GifRepository repository;

  GifSearch(this.repository);

  Future<List<GifEntity>> call({
    required String query,
    int limit = 25,
    int offset = 0,
  }) {
    return repository.search(query: query, limit: limit, offset: offset);
  }
}
