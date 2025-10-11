import 'package:bloc/bloc.dart';

class GitHubClientCubit extends Cubit<int> {
  GitHubClientCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
