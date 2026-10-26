import 'dart:math';

/// Utility class responsible for generating secure, clean, and unambiguous
/// join codes for university classes.
class JoinCodeGenerator {
  /// 31 characters: English uppercase letters and digits.
  /// Deliberately excludes:
  /// - 'O' and '0' (confusing letter O vs zero)
  /// - 'I' and '1' (confusing letter I vs one)
  static const String allowedCharacters = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  /// Generates a random alphanumeric code of [length] characters (default 6).
  static String generate({int length = 6}) {
    if (length <= 0) {
      throw ArgumentError('Join code length must be greater than 0.');
    }

    final random = Random.secure();
    final buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      final randomIndex = random.nextInt(allowedCharacters.length);
      buffer.write(allowedCharacters[randomIndex]);
    }

    return buffer.toString();
  }
}
