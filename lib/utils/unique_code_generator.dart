import 'dart:math';

class UniqueCodeGenerator {
  static String generate(String uid, String username) {
    String uidPrefix = uid.substring(0, min(uid.length, 4));
    String sanitizedUsername = username.replaceAll(' ', '').toLowerCase();
    String usernamePrefix =
        sanitizedUsername.substring(0, min(sanitizedUsername.length, 4));

    return '#$usernamePrefix$uidPrefix';
  }
}
