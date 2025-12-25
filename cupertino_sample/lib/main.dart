import 'package:cupertino_sample/app.dart';
import 'package:cupertino_sample/model/app_state_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ChangeNotifierProvider<AppStateModel>(
      create: (context) => AppStateModel()..loadProducts(),
      child: const CupertinoStoreApp(),
    ),
  );
}
