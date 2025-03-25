import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/giphy_api_service.dart';
import '../domain/gif_model.dart';

typedef GifList = List<GifModel>;

// Provides the API service
final giphyApiServiceProvider = Provider<GiphyApiService>((ref) {
  return GiphyApiService();
});

// Stores the current search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// StateNotifierProvider to manage search state
final gifSearchProvider =
    StateNotifierProvider<GifSearchNotifier, AsyncValue<GifList>>(
  (ref) => GifSearchNotifier(ref.watch(giphyApiServiceProvider)),
);

class GifSearchNotifier extends StateNotifier<AsyncValue<GifList>> {
  final GiphyApiService _apiService;
  Timer? _debounce;
  String _currentQuery = '';
  int _offset = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  GifSearchNotifier(this._apiService) : super(const AsyncValue.loading());
  bool get isLoadingMore => _isLoadingMore;
  // Updates the search query and fetches GIFs
  void updateSearchQuery(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      if (_currentQuery != query) {
        _currentQuery = query;
        _offset = 0;
        _hasMore = true;
        searchGifs(query);
      }
    });
  }

  // Fetches GIFs from the API
  Future<void> searchGifs(String query) async {
    if (query.isEmpty) return;
    state = const AsyncValue.loading();
    try {
      final gifs = await _apiService.fetchGifs(query: query, offset: 0);
      _offset = gifs.length;
      _hasMore = gifs.isNotEmpty;
      state = AsyncValue.data(gifs);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> loadMoreGifs() async {
    if (_isLoadingMore || _currentQuery.isEmpty || !_hasMore) return;
    _isLoadingMore = true;
    state = state.whenData((gifs) => [...gifs]);
    try {
      final moreGifs =
          await _apiService.fetchGifs(query: _currentQuery, offset: _offset);
      if (moreGifs.isEmpty) {
        _hasMore = false;
      } else {
        _offset += moreGifs.length;
        state =
            state.whenData((existingGifs) => [...existingGifs, ...moreGifs]);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } finally {
      _isLoadingMore = false;
      state = state.whenData((gifs) => [...gifs]);
    }
  }
}
