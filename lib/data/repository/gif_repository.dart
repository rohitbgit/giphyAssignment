import 'package:giphy_assignment/data/sources/api_services.dart';
import 'package:giphy_assignment/domain/model/gif_entity.dart';
import 'package:giphy_assignment/domain/repository/gif_repo.dart';

class GifRepositoryImpl implements GifRepository{
  final GiphyRemoteDataSource remoteDataSource;

  GifRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<GifEntity>> getTrending({
    int limit = 25,
    int offset = 0,
  }) async {
    final dtos =
    await remoteDataSource.getTrending(limit: limit, offset: offset);
    return dtos;
  }

  @override
  Future<List<GifEntity>> search({
    required String query,
    int limit = 25,
    int offset = 0,
  }) async {
    final dtos = await remoteDataSource.search(
      query: query,
      limit: limit,
      offset: offset,
    );
    return dtos;
  }
}