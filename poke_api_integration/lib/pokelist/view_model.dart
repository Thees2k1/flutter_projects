import 'package:flutter/material.dart';

import '../core/models/pokemon.dart';
import '../core/poke_repo.dart';
import '../core/result.dart';

export '../core/models/pokemon.dart' show Pokemon;

enum PokeListStatus { initial, loading, success, failure }

class PokeListViewModal extends ChangeNotifier {
  PokeListViewModal({
    required PokeRepo repo,
    this.status = PokeListStatus.initial,
  }) : _repo = repo;

  final PokeRepo _repo;

  PokeListStatus status;
  final List<Pokemon> data = <Pokemon>[];
  String? error;
  String? loadMoreError;
  bool isLoadingMore = false;

  bool get hasMore => _repo.hasMore;

  Future<void> fetchData() async {
    status = PokeListStatus.loading;
    error = null;
    loadMoreError = null;
    notifyListeners();

    final result = await _repo.fetchInitialPage();
    switch (result) {
      case Success<List<Pokemon>>(:final data):
        this.data
          ..clear()
          ..addAll(data);
        status = PokeListStatus.success;
      case Failure<List<Pokemon>>(:final message):
        error = message;
        status = PokeListStatus.failure;
    }

    notifyListeners();
  }

  Future<void> fetchMore() async {
    if (isLoadingMore || !_repo.hasMore || status != PokeListStatus.success) {
      return;
    }

    isLoadingMore = true;
    loadMoreError = null;
    notifyListeners();

    final result = await _repo.fetchNextPage();
    switch (result) {
      case Success<List<Pokemon>>(:final data):
        this.data.addAll(data);
      case Failure<List<Pokemon>>(:final message):
        loadMoreError = message;
    }

    isLoadingMore = false;
    notifyListeners();
  }
}
