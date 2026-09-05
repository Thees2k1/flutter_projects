import 'package:flutter/material.dart';
import 'package:new_flutter_temp_project/srcs/adaptive_app/adaptive_app.dart';
import 'package:new_flutter_temp_project/srcs/adaptive_app/app_state.dart';
import 'package:provider/provider.dart';

class AdaptiveAppProvider {
  Widget provide() {
    return ChangeNotifierProvider<AuthedUserPlaylists>(
      create: (context) => AuthedUserPlaylists(),
      child: const AdaptiveApp(),
    );
  }
}
