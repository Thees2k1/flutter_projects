import 'package:bloc_samples/src/endless_list/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_observer.dart';

class EndlessList {
  static Widget get app => App();

  static BlocObserver get blocObserver => PostBlocObserver();
}
