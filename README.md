# giphyAssignment
Features
🔍 Search & Trending

Trending GIFs shown by default
Search GIFs with live results (debounced input)
Clear search → returns to trending GIFs

♾ Infinite Scrolling

Auto-load more GIFs as the user scrolls
Works for both trending & search mode

⚡ Performance Optimizations

Uses small/optimized GIF previews for fast loading
Debounced search reduces unnecessary network calls
Cached network images for smooth scrolling

🛠 Tech Stack
Frontend

Flutter (Dart)
BLoC (flutter_bloc)

API

Giphy API
Endpoints used:

Trending: https://api.giphy.com/v1/gifs/trending
Search: https://api.giphy.com/v1/gifs/search
