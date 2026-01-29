import 'package:formz/formz.dart';

enum FullNameValidationError { empty, invalid, tooShort }

class FullNameInput extends FormzInput<String, FullNameValidationError> {
  const FullNameInput.pure() : super.pure('');
  const FullNameInput.dirty([super.value = '']) : super.dirty();

  static const int minLength = 2;
  static final _nameRegex = RegExp(r"^[A-Za-z]+(?:[ '\-][A-Za-z]+)*$");

  @override
  FullNameValidationError? validator(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return FullNameValidationError.empty;
    if (trimmed.length < minLength) return FullNameValidationError.tooShort;
    if (!_nameRegex.hasMatch(trimmed)) return FullNameValidationError.invalid;
    return null;
  }
}
