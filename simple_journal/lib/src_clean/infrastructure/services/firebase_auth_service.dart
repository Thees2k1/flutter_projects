import 'package:simple_journal/src_clean/core/domain/entities/user.dart';
import 'package:simple_journal/src_clean/core/services/auth_service.dart';

class FirebaseAuthService extends AuthService {
  @override
  Stream<User?> authState() {
    // TODO: implement authState
    throw UnimplementedError();
  }

  @override
  Future<User?> signIn(String email, String password) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
