import 'package:bloc_samples/src/endless_list/bloc/post_bloc.dart';
import 'package:bloc_samples/src/endless_list/services/http_api_service.dart';
import 'package:bloc_samples/src/endless_list/widgets/posts_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

const String _baseUrl = 'jsonplaceholder.typicode.com';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = HttpApiService(
      baseUrl: _baseUrl,
      httpClient: http.Client(),
    );
    return Scaffold(
      body: BlocProvider(
        create: (_) => PostBloc(apiService: apiService)..add(PostFetched()),
        child: const PostsList(),
      ),
    );
  }
}
