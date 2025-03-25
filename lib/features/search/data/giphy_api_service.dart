import 'package:dio/dio.dart';
import '../domain/gif_model.dart';

class GiphyApiService {
  final Dio _dio;
  final String _apiKey = 'O6fzs4IKe6kfJYdrNWRFjTxjmnQKZARo';
  final String _baseUrl = 'https://api.giphy.com/v1/gifs';

  GiphyApiService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<GifModel>> fetchGifs({
    required String query,
    int limit = 25,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/search',
        queryParameters: {
          'api_key': _apiKey,
          'q': query,
          'limit': limit,
          'offset': offset,
          'rating': 'g',
          'lang': 'en',
        },
      );
      final List<dynamic> data = response.data['data'];
      return data.map((json) => GifModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch GIFs: $e');
    }
  }
}
