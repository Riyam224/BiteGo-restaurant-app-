import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty,
  tooShort,
  missingUppercase,
  missingLowercase,
  missingNumber,
  missingSpecial,
}

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([super.value = '']) : super.dirty();

  static const int minLength = 8;
  static final _uppercase = RegExp(r'[A-Z]');
  static final _lowercase = RegExp(r'[a-z]');
  static final _number = RegExp(r'[0-9]');
  static final _special = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/]');

  @override
  PasswordValidationError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return PasswordValidationError.empty;
    if (trimmed.length < minLength) return PasswordValidationError.tooShort;
    if (!_uppercase.hasMatch(trimmed)) {
      return PasswordValidationError.missingUppercase;
    }
    if (!_lowercase.hasMatch(trimmed)) {
      return PasswordValidationError.missingLowercase;
    }
    if (!_number.hasMatch(trimmed)) return PasswordValidationError.missingNumber;
    if (!_special.hasMatch(trimmed)) {
      return PasswordValidationError.missingSpecial;
    }
    return null;
  }
}
