import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../models/post.dart';
import '../services/api_service.dart';

part 'post_event.dart';
part 'post_state.dart';

const kThrottleDuration = Duration(milliseconds: 100);
const _kPostLimit = 20;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required IApiService apiService})
    : _apiService = apiService,
      super(const PostState()) {
    on<PostFetched>(
      _onFetched,
      transformer: throttleDroppable(kThrottleDuration),
    );
  }

  final IApiService _apiService;

  Future<void> _onFetched(PostFetched event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return;

    try {
      final posts = await _fetchPosts(startIndex: state.posts.length);

      if (posts.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      }

      emit(
        state.copyWith(
          status: PostStatus.success,
          posts: [...state.posts, ...posts],
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<List<Post>> _fetchPosts({required int startIndex}) async {
    return _apiService.fetchPosts(startIndex: startIndex, limit: _kPostLimit);
  }
}
