import 'package:flutter/material.dart';
import 'package:giphy_assignment/domain/model/gif_entity.dart';

class GifTile extends StatelessWidget {
  final GifEntity gif;

  const GifTile({super.key, required this.gif});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(gif.url, fit: BoxFit.cover),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    gif.title.isEmpty ? 'Untitled GIF' : gif.title,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GridTile(
          footer: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            color: Colors.black54,
            child: Text(
              gif.title.isEmpty ? 'GIF' : gif.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          child: Image.network(
            gif.url,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) =>
            const Center(child: Icon(Icons.broken_image)),
          ),
        ),
      ),
    );
  }
}
