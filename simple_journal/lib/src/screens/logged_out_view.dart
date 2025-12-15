import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_journal/src/utils/app_state.dart';

class LoggedOutView extends StatelessWidget {
  final AppState state;
  const LoggedOutView({super.key, required this.state});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Emulator Suite Codelab')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please log in',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await state.logIn('go@gmail.com', '123456').then((_) {
                    if (state.user != null) {
                      context.go('/');
                    }
                  });
                },
                child: const Text('Log In'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
