/// A type-safe wrapper for UUIDv4 user identifiers.
///
/// Ensures the ID is exactly 36 characters long and follows UUIDv4 format.
class UserId {
  const UserId._(this.value);

  /// Creates a [UserId] from a string value.
  ///
  /// Throws [ArgumentError] if the value is not a valid UUIDv4 format
  /// (36 characters with proper hyphen placement).
  factory UserId(String value) {
    if (!_isValidUuid(value)) {
      throw ArgumentError('Invalid UUID format: $value');
    }
    return UserId._(value);
  }

  final String value;

  static bool _isValidUuid(String value) {
    if (value.length != 36) return false;
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return uuidRegex.hasMatch(value);
  }

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) => other is UserId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// A type-safe wrapper for user names.
///
/// Ensures the name is 4-32 characters long and contains only alphabetical letters.
class UserName {
  const UserName._(this.value);

  /// Creates a [UserName] from a string value.
  ///
  /// Throws [ArgumentError] if the value is not 4-32 characters long
  /// or contains non-alphabetical characters.
  factory UserName(String value) {
    if (value.length < 4 || value.length > 32) {
      throw ArgumentError('Name must be 4-32 characters long: $value');
    }
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      throw ArgumentError(
        'Name must contain only alphabetical letters: $value',
      );
    }
    return UserName._(value);
  }

  final String value;

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) => other is UserName && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// A type-safe wrapper for user biographies.
///
/// Ensures the biography is no longer than 255 characters.
class UserBio {
  const UserBio._(this.value);

  /// Creates a [UserBio] from a string value.
  ///
  /// Throws [ArgumentError] if the value is longer than 255 characters.
  factory UserBio(String value) {
    if (value.length > 255) {
      throw ArgumentError(
        'Bio must be no longer than 255 characters: ${value.length}',
      );
    }
    return UserBio._(value);
  }

  final String value;

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) => other is UserBio && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Represents a user in the system with validated fields.
class User {
  const User({required this.id, this.name, this.bio});

  /// The unique identifier for this user in UUIDv4 format.
  final UserId id;

  /// The user's display name (4-32 alphabetical characters).
  final UserName? name;

  /// The user's biography (up to 255 characters).
  final UserBio? bio;
}

/// Backend service for user data operations.
class Backend {
  /// Retrieves a user by their ID.
  Future<User> getUser(UserId id) async => User(id: id);

  /// Updates a user's information.
  Future<void> putUser(UserId id, {UserName? name, UserBio? bio}) async {}
}

/// Service layer for user operations.
class UserService {
  /// Creates a new [UserService] with the given [backend].
  UserService(this.backend);

  /// The backend service used for data operations.
  final Backend backend;

  /// Retrieves a user by their ID.
  ///
  /// Returns the [User] if found, throws an exception if not found.
  Future<User> get(UserId id) async {
    return await backend.getUser(id);
  }

  /// Updates an existing user's information.
  ///
  /// Takes a [User] object and updates the corresponding record in the backend.
  Future<void> update(User user) async {
    await backend.putUser(user.id, name: user.name, bio: user.bio);
  }
}

void main() {
  // Example usage with type-safe newtypes
  try {
    final userId = UserId('550e8400-e29b-41d4-a716-446655440000');
    final userName = UserName('JohnDoe');
    final userBio = UserBio('A passionate developer');

    final user = User(id: userId, name: userName, bio: userBio);
    print('Created user: ${user.id} - ${user.name}');
  } catch (e) {
    print('Error: $e');
  }
}
