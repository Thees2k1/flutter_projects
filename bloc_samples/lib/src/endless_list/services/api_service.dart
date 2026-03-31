import '../models/post.dart';

abstract class IApiService {
  Future<List<Post>> fetchPosts({required int startIndex, required int limit});
}
