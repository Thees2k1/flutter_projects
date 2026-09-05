import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:local_auth/entities.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart'
    show Database, getDatabasesPath, openDatabase;

enum SimpleLifeState { contructed, initialized, isBlocking, disposed }

abstract class AuthDataStore {
  static const int defaultLimit = 10;
  int get sessionsThreshold;

  Future<void> updateUser(String userId, Map<String, dynamic> patch);
  Future<void> deleteUser(String userId);
  Future<void> insertUser(User user, String passwordHash);
  Future<List<User>> findUsersBy({
    String? email,
    String? id,
    String? passwordHash,
  });

  Future<void> insertSession(String userId, Session session);
  Future<List<Object?>> findAliveSessionsBy({
    String? userId,
    required String expiryStamp,
    required int take,
  });
  Future<void> deleteSession(String sessionToken);
  Future<void> dropOldSessions(String userId, [int? threshold]);
}

mixin OwnSimpleLifeCycle {
  SimpleLifeState get lifeState;
  Future<void> init();
  Future<void> dispose();
}

abstract class LifedAuthDataStore extends AuthDataStore
    with OwnSimpleLifeCycle {}

class SqfiteAuthDataStore extends LifedAuthDataStore {
  Database? _database;
  SimpleLifeState _lifeState = SimpleLifeState.contructed;

  @override
  int get sessionsThreshold => 10;

  static const String sessionTable = 'sessions';
  static const String userTable = 'users';
  static String get createUserTableQuery =>
      '''
  CREATE TABLE $userTable(
    id TEXT PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    display_name TEXT,
    photo_url TEXT,
    provider TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TEXT NOT NULL,
    last_sign_in_at TEXT NOT NULL,
    refresh_token TEXT,
    google_access_token TEXT,
    google_id_token TEXT,
    roles TEXT
  )
''';
  static String get createSessionTableQuery =>
      '''
  CREATE TABLE $sessionTable(
    id INTERGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL,
    session_token TEXT NOT NULL,
    created_at TEXT NOT NULL,
    expires_at TEXT NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id)
  )
''';

  @override
  SimpleLifeState get lifeState => _lifeState;

  @override
  Future<void> init() async {
    assert(
      _lifeState == SimpleLifeState.contructed,
      'Database is already initialized or disposed',
    );
    await _initDatabase();
    _lifeState = SimpleLifeState.initialized;
  }

  @override
  Future<void> dispose() async {
    assert(
      _lifeState != SimpleLifeState.disposed,
      'Database is already disposed',
    );
    await _database?.close();
    _lifeState = SimpleLifeState.disposed;
  }

  @override
  Future<List<Session>> findAliveSessionsBy({
    String? userId,
    required String expiryStamp,
    int take = AuthDataStore.defaultLimit,
  }) async {
    if (_lifeState != SimpleLifeState.initialized) {
      throw DatabaseException.notInitialized;
    }
    final whereClause = StringBuffer('expires_at > ?');
    final whereArgs = [expiryStamp];

    if (userId != null) {
      whereClause.write(' AND user_id = ?');
      whereArgs.add(userId);
    }

    final result = await _database!.query(
      sessionTable,
      where: whereClause.toString(),
      whereArgs: whereArgs,
      limit: take,
    );

    return result.map((record) => Session.fromJson(record)).toList();
  }

  @override
  Future<void> insertUser(User user, String passwordHash) {
    if (_lifeState != SimpleLifeState.initialized) {
      throw DatabaseException.notInitialized;
    }
    return _database!.insert('users', {
      ...user.toJson(),
      'password_hash': passwordHash,
      'created_at': user.createdAt.toIso8601String(),
      'last_sign_in_at': user.lastSignInAt.toIso8601String(),
    });
  }

  @override
  Future<List<User>> findUsersBy({
    String? email,
    String? id,
    String? passwordHash,
  }) async {
    if (_lifeState != SimpleLifeState.initialized) {
      throw DatabaseException.notInitialized;
    }
    final StringBuffer whereClause = StringBuffer();
    final List<String> whereArgs = [];

    if (email != null) {
      whereClause.write('email = ?');
      whereArgs.add(email);
    }
    if (id != null) {
      if (whereClause.isNotEmpty) whereClause.write(' AND ');
      whereClause.write('id = ?');
      whereArgs.add(id);
    }
    if (passwordHash != null) {
      if (whereClause.isNotEmpty) whereClause.write(' AND ');
      whereClause.write('password_hash = ?');
      whereArgs.add(passwordHash);
    }
    final results = await _database!.query(
      'users',
      where: whereClause.isNotEmpty ? whereClause.toString() : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    //this step is not strictly necessary, but it ensures that the whereClause and whereArgs are cleared after the query, preventing potential issues if this method is called multiple times in a row.
    whereClause.clear();
    whereArgs.clear();

    return results.map((record) => User.fromJson(record)).toList();
  }

  @override
  Future<void> updateUser(String userId, Map<String, Object?> patch) async {
    if (_lifeState != SimpleLifeState.initialized) {
      throw DatabaseException.notInitialized;
    }
    await _database!.update(
      'users',
      {...patch},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  @override
  Future<void> insertSession(String userId, Session session) async {
    // it's best to ensure the database is intialized with Exception instead of assert, because assert is only active in debug mode, and we want to ensure that the database is initialized in all environments.
    if (_lifeState != SimpleLifeState.initialized) {
      throw Exception('Database is not initialized');
    }
    await _database!.insert('sessions', {
      'user_id': userId,
      'session_token': session.token,
      'created_at': session.createdAt.toIso8601String(),
      'expires_at': session.expiresAt.toIso8601String(),
    });
  }

  @override
  Future<void> deleteUser(String userId) async {
    assert(
      _lifeState == SimpleLifeState.initialized,
      'Database is not initialized',
    );
    await _database!.delete('users', where: 'id = ?', whereArgs: [userId]);
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'auth_service.db'),
      onCreate: (database, version) async {
        await database.execute(createUserTableQuery);
        await database.execute(createSessionTableQuery);
      },
      version: 1,
    );
  }

  @override
  Future<void> deleteSession(String sessionToken) async {
    assert(
      _lifeState == SimpleLifeState.initialized,
      'Database is not initialized',
    );
    try {
      await _database!.delete(
        'sessions',
        where: 'session_token = ?',
        whereArgs: [sessionToken],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error during deleteSession: $e');
      }
    }
  }

  @override
  Future<void> dropOldSessions(String userId, [int? threshold]) async {
    assert(
      _lifeState == SimpleLifeState.initialized,
      'Database is not initialized',
    );
    final oldIndexPointer = threshold ?? sessionsThreshold;
    final sessions = await _database!.query(
      'sessions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    if (sessions.length > oldIndexPointer) {
      final sessionsToDelete = sessions.skip(oldIndexPointer);
      for (final session in sessionsToDelete) {
        _database!.delete(
          'sessions',
          where: 'id = ?',
          whereArgs: [session['id']],
        );
      }
    }
  }
}

abstract class AuthService {
  Stream<User?> get user;
  User? get currentUser;

  Future<Result<User?, Object?>> signUp(String email, String password);
  Future<Result<User?, Object?>> signInWithEmail(String email, String password);
  Future<void> signOut();

  Future<void> refreshSession();
  Future<bool> checkIfAuthenticated();
  Future<void> deleteAccount();
  Future<void> updateUserProfile({String? displayName, String? photoUrl});

  // Authorization methods
  Future<bool> hasRole(String role);
  Future<List<String>> getUserRoles();
}

class LocalAuthService extends AuthService with OwnSimpleLifeCycle {
  static LocalAuthService? _instance;

  late final LifedAuthDataStore _dataStore;

  User? _currentUser;
  final _userController = StreamController<User?>.broadcast();

  SimpleLifeState _currentState = SimpleLifeState.contructed;

  static const Duration defaultSessionDuration = Duration(days: 7);
  @override
  SimpleLifeState get lifeState => _currentState;

  factory LocalAuthService() {
    _instance ??= LocalAuthService._();
    return _instance!;
  }

  LocalAuthService._() {
    _dataStore = SqfiteAuthDataStore();
    init().then((_) {
      _currentState = SimpleLifeState.initialized;
    });
  }

  @override
  Future<void> init() async {
    assert(
      _currentState == SimpleLifeState.contructed,
      'AuthService is already initialized or disposed',
    );
    await _dataStore.init();
    await _restoreSession();

    _currentState = SimpleLifeState.initialized;
  }

  @override
  Future<void> dispose() async {
    assert(
      _currentState != SimpleLifeState.disposed,
      'AuthService is already disposed',
    );
    _userController.close();
    _dataStore.dispose();
    _currentState = SimpleLifeState.disposed;
  }

  @override
  Stream<User?> get user => _userController.stream;

  @override
  User? get currentUser => _currentUser;

  String _hashPassword(String password) {
    return Helpers.hashWithSha256(password);
  }

  String _generateSessionToken() {
    //milliseconds since epoch as a string to ensure uniqueness
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final randomValueByDateTimeinMillis = DateTime.now().microsecondsSinceEpoch
        .toString();

    final combinedString = '$timestamp$randomValueByDateTimeinMillis';
    return Helpers.hashWithSha256(combinedString);
  }

  @override
  Future<Result<User?, String>> signUp(String email, String password) async {
    assert(
      _currentState == SimpleLifeState.initialized,
      'AuthService is not initialized',
    );
    try {
      final existingUsers = await _dataStore.findUsersBy(email: email);
      if (existingUsers.isNotEmpty) {
        return Result.error(ServiceErrors.emailAlreadyInUse);
      }

      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();
      final passwordHash = _hashPassword(password);

      final newUser = User(
        id: id,
        email: email,
        lastSignInAt: now,
        provider: .emailPassword,
        createdAt: DateTime.now(),
        roles: [Roles.user], // Default role
      );

      await _dataStore.insertUser(newUser, passwordHash);

      _currentUser = newUser;
      _userController.add(_currentUser);
      return Result.success(_currentUser);
    } on DatabaseException catch (e) {
      return Result.error(e.message);
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error during signUp: $e');
      }
      return Result.error(ServiceErrors.sometingWentWrong);
    }
  }

  @override
  Future<Result<User?, String>> signInWithEmail(
    String email,
    String password,
  ) async {
    if (_currentState != SimpleLifeState.initialized) {
      return Result.error(ServiceErrors.internalError);
    }

    try {
      final users = await _dataStore.findUsersBy(
        email: email,
        passwordHash: _hashPassword(password),
      );
      if (users.isEmpty) {
        throw Exception('Invalid email or password');
      }

      final user = users.first;
      await _createSession(user.id);

      _currentUser = user;
      _userController.add(_currentUser);
      return Result.success(_currentUser);
    } on DatabaseException catch (e) {
      return Result.error(e.message);
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error during signInWithEmail: $e');
      }
      return Result.error(ServiceErrors.invalidCredentials);
    }
  }

  @override
  Future<void> signOut() async {
    assert(
      _currentState == SimpleLifeState.initialized,
      'AuthService is not initialized',
    );
    try {
      if (_currentUser != null) {
        await _dataStore.deleteUser(_currentUser!.id);
        _currentUser = null;
        _userController.add(_currentUser);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during signOut: $e');
      }
      throw Exception(ServiceErrors.sometingWentWrong);
    }
  }

  Future<void> _restoreSession() async {
    if (_currentState != SimpleLifeState.initialized) {
      return;
    }

    try {
      final sessions = await _dataStore.findAliveSessionsBy(
        expiryStamp: DateTime.now().toIso8601String(),
        take: 1,
      );

      if (sessions.isNotEmpty) {
        final session = sessions.first as Session;
        final users = await _dataStore.findUsersBy(id: session.userId);
        if (users.isNotEmpty) {
          _currentUser = users.first;
          _userController.add(_currentUser);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during _restoreSession: $e');
      }
    }
  }

  @override
  Future<void> refreshSession() async {
    assert(
      _currentState == SimpleLifeState.initialized,
      'AuthService is not initialized',
    );
    try {
      final users = await _dataStore.findUsersBy(id: _currentUser?.id);
      if (users.isEmpty) {
        await signOut();
        return;
      }

      _currentUser = users.first;
      _userController.add(_currentUser);
    } catch (e) {
      if (kDebugMode) {
        print('Error during refreshSession: $e');
      }
      throw Exception(ServiceErrors.sometingWentWrong);
    }
  }

  @override
  Future<bool> checkIfAuthenticated() async {
    if (_currentUser == null || _currentState != SimpleLifeState.initialized) {
      return false;
    }

    final sessions = await _dataStore.findAliveSessionsBy(
      userId: _currentUser!.id,
      expiryStamp: DateTime.now().toIso8601String(),
      take: 1,
    );
    return sessions.isNotEmpty;
  }

  @override
  Future<void> deleteAccount() async {
    if (currentUser == null) {
      return;
    }

    try {
      await _dataStore.deleteUser(currentUser!.id);
      await signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Error during deleteAccount: $e');
      }
    }
  }

  @override
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    assert(
      _currentState == SimpleLifeState.initialized,
      'AuthService is not initialized',
    );
    if (currentUser == null) {
      throw Exception('No user is currently signed in');
    }

    if (displayName == null && photoUrl == null) {
      return; // No changes to update
    }
    final cachedUser = currentUser!;

    try {
      _currentUser = _currentUser!.copyWith(
        displayName: displayName,
        photoUrl: photoUrl,
      );
      _userController.add(_currentUser);

      final patch = <String, Object?>{};
      if (displayName != null &&
          displayName.isNotEmpty &&
          displayName != currentUser!.displayName) {
        patch['display_name'] = displayName;
      }
      if (photoUrl != null &&
          photoUrl.isNotEmpty &&
          photoUrl != currentUser!.photoUrl) {
        patch['photo_url'] = photoUrl;
      }
      if (patch.isEmpty) {
        return; // No changes to update
      }

      _dataStore.updateUser(currentUser!.id, patch);
    } catch (e) {
      if (kDebugMode) {
        print('Error during updateUserProfile: $e');
      }
      _currentUser = cachedUser;
      _userController.add(_currentUser);
    }
  }

  @override
  Future<bool> hasRole(String role) {
    if (currentUser == null) return Future.value(false);
    return Future.value(currentUser!.roles.contains(role));
  }

  @override
  Future<List<String>> getUserRoles() async {
    if (currentUser == null) {
      return [];
    } else {
      return currentUser!.roles;
    }
  }

  Future<void> _createSession(String id) async {
    assert(
      _currentState == SimpleLifeState.initialized,
      'AuthService is not initialized',
    );
    try {
      final sessionToken = _generateSessionToken();
      final now = DateTime.now();
      final session = Session(
        id: 0, // This will be auto-incremented by the database
        userId: id,
        token: sessionToken,
        createdAt: now,
        expiresAt: now.add(defaultSessionDuration),
      );
      await _dataStore.insertSession(id, session);
      await _dataStore.dropOldSessions(id);
    } catch (e) {
      if (kDebugMode) {
        print('Error during _createSession: $e');
      }
    }
  }
}

extension AuthServiceScope on BuildContext {
  void logoutUser() {
    read<AuthService>().signOut();
  }

  Stream<User?> get currentUser => watch<AuthService>().user;
}
