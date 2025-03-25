import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_search_app/features/search/application/search_provider.dart';
import 'package:gif_search_app/features/search/domain/gif_model.dart';
import 'mocks.mocks.dart';

void main() {
  late MockGiphyApiService mockApiService;
  late ProviderContainer container;

  setUp(() {
    mockApiService = MockGiphyApiService();
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('Initial state should be loading', () {
    final notifier = GifSearchNotifier(mockApiService);
    expect(notifier.state, const AsyncValue.loading());
  });

  test('Search should return GIFs when API call is successful', () async {
    final fakeGifs = [
      GifModel(id: '1', title: 'Test', images: {
        'preview_gif': {'url': 'url1'},
        'original': {'url': 'url1'}
      })
    ];

    when(mockApiService.fetchGifs(query: 'funny', offset: 0))
        .thenAnswer((_) async => fakeGifs);

    final notifier = GifSearchNotifier(mockApiService);
    await notifier.searchGifs('funny');

    expect(notifier.state, AsyncValue.data(fakeGifs));
  });

  test('Search should return an error when API fails', () async {
    when(mockApiService.fetchGifs(query: 'funny', offset: 0))
        .thenThrow(Exception('API error'));

    final notifier = GifSearchNotifier(mockApiService);
    await notifier.searchGifs('funny');

    expect(notifier.state.hasError, true);
  });

  test('Check if Load more GIFs works ', () async {
    final initialGifs = [
      GifModel(id: '1', title: 'Test1', images: {
        'preview_gif': {'url': 'url1'},
        'original': {'url': 'url1'}
      })
    ];
    final moreGifs = [
      GifModel(id: '2', title: 'Test2', images: {
        'preview_gif': {'url': 'url1'},
        'original': {'url': 'url1'}
      })
    ];

    when(mockApiService.fetchGifs(query: 'funny', offset: 0))
        .thenAnswer((_) async => initialGifs);
    when(mockApiService.fetchGifs(query: 'funny', offset: 1))
        .thenAnswer((_) async => moreGifs);

    final notifier = GifSearchNotifier(mockApiService);
    await notifier.searchGifs('funny');
    await notifier.loadMoreGifs();

    expect(notifier.state.value, [...initialGifs, ...moreGifs]);
  });
}
