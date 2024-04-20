class Validators {
  static String? validateUsername(String? input) {
    if (input == null || input.isEmpty) {
      return "Your username cannot be empty";
    }

    if (input.length < 5) {
      return "Your username must be at least 5 characters long";
    }

    RegExp regex = RegExp(r'^[a-zA-Z0-9]*$');
    if (!regex.hasMatch(input)) {
      return "Your username must contain only alphanumeric characters";
    }

    return null;
  }

  static String? validateEmail(String? input) {
    if (input == null || input.isEmpty) {
      return "Your email cannot be empty";
    }

    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(input)) {
      return "Please enter a valid email address";
    }

    return null;
  }

  static String? validatePassword(String? input) {
    if (input == null || input.isEmpty) {
      return "Your password cannot be empty";
    }

    if (input.length < 8) {
      return "Your password must be at least 8 characters long";
    }

    return null;
  }
}
