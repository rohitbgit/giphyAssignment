import 'package:giphy_assignment/domain/model/gif_entity.dart';

abstract class GifRepository {
  Future<List<GifEntity>> getTrending({
    int limit,
    int offset,
  });

  Future<List<GifEntity>> search({
    required String query,
    int limit,
    int offset,
  });
}
