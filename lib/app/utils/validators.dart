class Validators {
  // Email validation
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Password validation
  static bool isValidPassword(String password) {
    // At least 6 characters
    return password.length >= 6;
  }

  static bool isStrongPassword(String password) {
    // At least 8 characters, contains uppercase, lowercase, number, and special character
    if (password.length < 8) return false;
    
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    return hasUppercase && hasLowercase && hasDigit && hasSpecialChar;
  }

  // Name validation
  static bool isValidName(String name) {
    return name.trim().isNotEmpty && name.length >= 2;
  }

  // Phone validation
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    return phoneRegex.hasMatch(phone);
  }

  // URL validation
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Generic required field validation
  static bool isRequired(String value) {
    return value.trim().isNotEmpty;
  }

  // Min length validation
  static bool hasMinLength(String value, int minLength) {
    return value.length >= minLength;
  }

  // Max length validation
  static bool hasMaxLength(String value, int maxLength) {
    return value.length <= maxLength;
  }
}
