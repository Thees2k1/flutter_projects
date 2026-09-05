import 'dart:convert';

import 'package:crypto/crypto.dart';

class User {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final AuthProvider provider;
  final DateTime createdAt;
  final DateTime lastSignInAt;
  final TokenRegistry tokenRegistry;
  final List<String> roles;

  User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.tokenRegistry = const TokenRegistry(),
    required this.provider,
    required this.createdAt,
    required this.lastSignInAt,
    this.roles = const [Roles.user],
  });

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    AuthProvider? provider,
    DateTime? createdAt,
    DateTime? lastSignInAt,
    TokenRegistry? tokenRegistry,
    List<String>? roles,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      provider: provider ?? this.provider,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      tokenRegistry: tokenRegistry ?? this.tokenRegistry,
      roles: roles ?? this.roles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'provider': provider.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'last_sign_in_at': lastSignInAt.toIso8601String(),
      'token_registry': {
        'access_token': tokenRegistry.accessToken,
        'refresh_token': tokenRegistry.refreshToken,
        'google_access_token': tokenRegistry.googleAccessToken,
        'google_id_token': tokenRegistry.googleIdToken,
        'expires_at': tokenRegistry.expiresAt?.toIso8601String(),
      },
      'roles': roles,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      displayName: json['display_name'],
      photoUrl: json['photo_url'],
      provider: AuthProvider.values.firstWhere(
        (e) => e.toString().split('.').last == json['provider'],
        orElse: () => AuthProvider.emailPassword,
      ),
      createdAt: DateTime.parse(json['created_at']),
      lastSignInAt: DateTime.parse(json['last_sign_in_at']),
      tokenRegistry: TokenRegistry(
        accessToken: json['token_registry']['access_token'],
        refreshToken: json['token_registry']['refresh_token'],
        googleAccessToken: json['token_registry']['google_access_token'],
        googleIdToken: json['token_registry']['google_id_token'],
        expiresAt: json['token_registry']['expires_at'] != null
            ? DateTime.parse(json['token_registry']['expires_at'])
            : null,
      ),
      roles: List<String>.from(json['roles'] ?? []),
    );
  }
}

class Roles {
  static const String user = 'user';
  static const String admin = 'admin';
  static const String moderator = 'moderator';
}

enum AuthProvider { emailPassword, google }

class TokenRegistry {
  final String? accessToken;
  final String? refreshToken;
  final String? googleAccessToken;
  final String? googleIdToken;
  final DateTime? expiresAt;

  const TokenRegistry({
    this.accessToken,
    this.refreshToken,
    this.googleAccessToken,
    this.googleIdToken,
    this.expiresAt,
  });

  TokenRegistry copyWith({
    String? accessToken,
    String? refreshToken,
    String? googleAccessToken,
    String? googleIdToken,
    DateTime? expiresAt,
  }) {
    return TokenRegistry(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      googleAccessToken: googleAccessToken ?? this.googleAccessToken,
      googleIdToken: googleIdToken ?? this.googleIdToken,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

class Helpers {
  static String hashWithSha256(String input) {
    //this is a simple implementation of hashing a string using SHA-256 algorithm, it takes an input string, encodes it to bytes using UTF-8 encoding, then computes the SHA-256 hash of the bytes and returns the hash as a hexadecimal string.
    // the algorithm is widely used in cryptography and data integrity verification, and it produces a fixed-size output (256 bits) regardless of the input size.
    // the downside is that it is a one-way function, meaning you cannot retrieve the original input from the hash, which is a desirable property for password storage and verification.
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static String? emailValidator(String? input) {
    return null;
  }

  static String? passwordValidator(String? input) {}
  static String? nameValidator(String? input) {}
}

abstract class EventListener {
  void onEvent(String eventType, dynamic data);
  void onError(String errorType, dynamic error);
}

class Session {
  final int id;
  final String userId;
  final String token;
  final DateTime expiresAt;
  final DateTime createdAt;

  const Session({
    required this.id,
    required this.userId,
    required this.token,
    required this.createdAt,
    required this.expiresAt,
  });

  static Session fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      userId: json['user_id'],
      token: json['session_token'],
      createdAt: DateTime.parse(json['created_at']),
      expiresAt: DateTime.parse(json['expires_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_token': token,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'user_id': userId,
      'id': id,
    };
  }

  Session copyWith({String? token, DateTime? expiresAt}) {
    return Session(
      id: id,
      userId: userId,
      token: token ?? this.token,
      createdAt: createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  String toString() {
    return 'Session(token: $token, expiresAt: $expiresAt)';
  }
}

//Exceptions
class DatabaseException implements Exception {
  final String message;
  const DatabaseException([
    this.message = 'An error occurred while accessing the database.',
  ]);

  @override
  String toString() => 'DatabaseNotInitializedException: $message';

  static DatabaseException fromError(dynamic error) {
    return DatabaseException(error.toString());
  }

  static DatabaseException fromMessage(String message) {
    return DatabaseException(message);
  }

  static const DatabaseException notInitialized = DatabaseException(
    'Database is not initialized',
  );
}

class ServiceErrors {
  static const String sometingWentWrong = 'Something went wrong';
  static const String internalError = 'Internal error';
  static const String userNotFound = 'User not found';
  static const String invalidCredentials = 'Invalid credentials';
  static const String userAlreadyExists = 'User already exists';
  static const String invalidEmail = 'Invalid email';
  static const String emailAlreadyInUse = 'Email already in use';
}

//Result object
class ResultBase<T> {
  final T? data;
  final String? error;

  ResultBase({this.data, this.error});

  bool get isSuccess => error == null;
  bool get isError => error != null;

  @override
  String toString() {
    if (isSuccess) {
      return 'Result(data: $data)';
    } else {
      return 'Result(error: $error)';
    }
  }
}

sealed class Result<T, E extends Object?> {
  factory Result.success(T data) => SuccessResult(data);
  factory Result.error(E error) => ErrorResult(error);
}

class SuccessResult<T, E> implements Result<T, E> {
  final T data;
  SuccessResult(this.data);

  @override
  String toString() => 'Result.success(data: $data)';
}

class ErrorResult<T, E> implements Result<T, E> {
  final E error;
  ErrorResult(this.error);

  @override
  String toString() => 'Result.error(error: $error)';
}

// command expects no return value, while query expects a return value of type T. Both can return an error of type E.
abstract class CommandUseCase<T, E extends Object?> {
  // Enforcing the result type to be void for commands, as they don't return a value, but can still return an error of type E.
  // Future<Result<void, E>> execute();
  //utilizing dart call behavior
  Future<Result<void, E>> call();
}

abstract class QueryUseCase<T, E extends Object?> {
  Future<Result<T, E>> call();
}
