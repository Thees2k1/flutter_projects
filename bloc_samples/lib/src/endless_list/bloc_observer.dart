import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

class PostBlocObserver extends BlocObserver {
  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    debugPrint("  Transition: $transition");
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint("  Error: $error, StackTrace: $stackTrace");
    super.onError(bloc, error, stackTrace);
  }
}
