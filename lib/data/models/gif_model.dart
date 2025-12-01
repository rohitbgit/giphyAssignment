import 'package:giphy_assignment/domain/model/gif_entity.dart';

class GifModel extends GifEntity {
  GifModel({
    required super.id,
    required super.title,
    required super.url,
  });

  factory GifModel.fromJson(Map<String, dynamic> json) {
    final images = json['images'] ?? {};

    final small = images['fixed_width_small'] ?? images['preview_gif'] ?? images['downsized_small'];

    final gifUrl = small != null ? small['url'] : '';


    return GifModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      url: gifUrl,
    );
  }
}
