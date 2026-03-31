import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_journal/src/screens/logged_in_view.dart';
import 'package:simple_journal/src/screens/logged_out_view.dart';
import 'package:simple_journal/src/utils/app_state.dart';
import 'package:simple_journal/src/utils/initialize_firebase_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebaseServices();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final state = AppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scrollBehavior: ScrollBehavior(),
      routerConfig: _router(),
      theme: ThemeData(),
    );
  }

  GoRouter _router() {
    return GoRouter(
      redirect: (context, routerState) => state.user == null ? '/login' : null,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, routerState) => LoggedInView(state: state),
        ),
        GoRoute(
          path: '/login',
          builder: (context, routerState) => LoggedOutView(state: state),
        ),
      ],
    );
  }
}
