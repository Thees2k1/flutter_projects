import 'dart:convert';

import 'package:bloc_samples/src/endless_list/models/post.dart';

import 'api_service.dart';
import 'package:http/http.dart' as http;

class HttpApiService extends IApiService {
  HttpApiService({required this.baseUrl, required http.Client httpClient})
    : _httpClient = httpClient;

  final String baseUrl;
  final http.Client _httpClient;

  @override
  Future<List<Post>> fetchPosts({
    required int startIndex,
    required int limit,
  }) async {
    final response = await _httpClient.get(
      Uri.https(baseUrl, '/posts', {
        '_start': '$startIndex',
        '_limit': '$limit',
      }),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic e) {
        final map = e as Map<String, dynamic>;
        return Post(
          id: map['id'] as int,
          title: map['title'] as String,
          body: map['body'] as String,
        );
      }).toList();
    }

    throw Exception('error fetching posts');
  }
}
