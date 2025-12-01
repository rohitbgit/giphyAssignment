import 'dart:convert';
import 'package:giphy_assignment/data/models/gif_model.dart';
import 'package:giphy_assignment/utils/app_url.dart';
import 'package:http/http.dart' as http;

abstract class GiphyRemoteDataSource {
  Future<List<GifModel>> getTrending({
    int limit,
    int offset,
  });

  Future<List<GifModel>> search({
    required String query,
    int limit,
    int offset,
  });
}

class GiphyRemoteDataSourceImpl implements GiphyRemoteDataSource {
  final http.Client client;

  GiphyRemoteDataSourceImpl({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<List<GifModel>> getTrending({
    int limit = 25,
    int offset = 0,
  }) async {
    final uri = Uri.parse(
      '${AppUrl.GIF_TRENDING}'
          '&limit=$limit&offset=$offset',
    );

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];
      return data.map((e) => GifModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load trending GIFs');
    }
  }

  @override
  Future<List<GifModel>> search({
    required String query,
    int limit = 25,
    int offset = 0,
  }) async {
    final uri = Uri.parse(
      '${AppUrl.GIF_SEARCH}'
          '&q=$query&limit=$limit&offset=$offset',
    );

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];
      return data.map((e) => GifModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search GIFs');
    }
  }
}