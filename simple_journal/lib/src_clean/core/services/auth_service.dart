import 'package:simple_journal/src_clean/core/domain/entities/user.dart';

abstract class AuthService {
  Future<User?> signIn(String email, String password);
  Future<void> signOut();
  Stream<User?> authState();
}
