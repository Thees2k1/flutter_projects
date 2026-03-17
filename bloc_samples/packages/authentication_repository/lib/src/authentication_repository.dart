import 'dart:async';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

typedef SimpleCredential = ({String username, String password});

class AuthenticationRepository {
  final _statusController = StreamController<AuthenticationStatus>();

  /// This stream will emit the current [AuthenticationStatus] whenever
  /// the authentication status changes.
  /// The stream will emit [AuthenticationStatus.unknown] if the authentication
  /// status is not known yet.
  Stream<AuthenticationStatus> get status async* {
    //await for 1 sec
    await Future.delayed(const Duration(seconds: 1));

    //yield the unauthenticated status
    yield AuthenticationStatus.unauthenticated;

    //yield the status from the controller stream
    yield* _statusController.stream;
  }

  /// This simple method is just a demo for the login process.
  Future<void> logIn({required SimpleCredential credential}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    /// add the authenticated status to the stream controller after a delay of 300 ms
    _statusController.add(AuthenticationStatus.authenticated);
  }

  void logOut() {
    /// add the unauthenticated status to the stream controller
    _statusController.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _statusController.close();

  /// close the stream controller when the repository is disposed
}
