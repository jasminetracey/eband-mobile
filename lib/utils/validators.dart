import 'package:eband/models/payment_card.dart';
import 'package:flutter/services.dart';

class Validators {
  static String validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is required';
    }

    const String p =
        '[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+';
    final RegExp regExp = RegExp(p);

    if (regExp.hasMatch(value)) {
      return null;
    }

    return 'Email is not valid';
  }

  static String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }

    // TODO: Increase validation
    if (value.length < 5) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  static String validateName(String value) {
    if (value.isEmpty) {
      return 'Name is required';
    }

    // TODO: Increase validation
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    } else {
      return null;
    }
  }

  static String validateType(String value) {
    if (value.isEmpty) {
      return 'Event Type is required';
    }

    // TODO: Increase validation
    if (value.length < 3) {
      return 'Event Type must be at least 3 characters';
    } else {
      return null;
    }
  }

  static String validateDescription(String value) {
    if (value.isEmpty) {
      return 'Description is required';
    }

    // TODO: Increase validation
    return null;
  }

  static String validateVenue(String value) {
    if (value.isEmpty) {
      return 'Venue is required';
    }

    // TODO: Increase validation
    if (value.length < 3) {
      return 'Venue must be at least 3 characters';
    } else {
      return null;
    }
  }

  static String validateAddress(String value) {
    if (value.isEmpty) {
      return 'Address is required';
    }

    // TODO: Increase validation
    if (value.length < 3) {
      return 'Address must be at least 3 characters';
    } else {
      return null;
    }
  }

  static String validateQuantity(String value) {
    if (value.isEmpty) {
      return 'Quantity is required';
    }

    if (int.parse(value) < 1) {
      return 'Quantity cannot be zero';
    } else {
      return null;
    }
  }

  static String validateCredits(String value) {
    if (value.isEmpty) {
      return 'Credits is required';
    }

    if (int.parse(value) < 1000) {
      return 'Minimum credits is 1000';
    } else {
      return null;
    }
  }

  static String validateCost(String value) {
    if (value.isEmpty) {
      return 'Cost is required';
    }

//    if (double.parse(value) < 1)
//      return 'Cost cannot be zero';
//    else
    return null;
  }

  static String validatePin(String value) {
    if (value.isEmpty) {
      return 'Pin is required';
    }

    if (value.length != 4) {
      return 'Pin should be 4 numbers';
    }

    return null;
  }

  static String validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Phone number is required';
    }

    if (value.length > 10) {
      return 'Phone number should be 10 digits';
    }
    return null;
  }

  static String validateConfirmPin(String value, String checkValue) {
    if (value.isEmpty) {
      return 'Pin Confirmation is required';
    }

    if (value != checkValue) {
      return 'Pin should match';
    }
    return null;
  }

  static String validateCVV(String value) {
    if (value.isEmpty) {
      return 'CVV is required';
    }

    if (value.length < 3 || value.length > 4) {
      return 'CVV is invalid';
    }
    return null;
  }

  static String validateDate(String value) {
    if (value.isEmpty) {
      return 'Expire date is required';
    }

    int year;
    int month;
    // The value contains a forward slash if the month and year has been
    // entered.
    if (value.contains(RegExp(r'(\/)'))) {
      final split = value.split(RegExp(r'(\/)'));
      // The value before the slash is the month while the value to right of
      // it is the year.
      month = int.parse(split[0]);
      year = int.parse(split[1]);
    } else {
      // Only the month was entered
      month = int.parse(value.substring(0, value.length));
      year = -1; // Lets use an invalid year intentionally
    }

    if ((month < 1) || (month > 12)) {
      // A valid month is between 1 (January) and 12 (December)
      return 'Expiry month is invalid';
    }

    final fourDigitsYear = _convertYearTo4Digits(year);
    if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
      // We are assuming a valid should be between 1 and 2099.
      // Note that, it's valid doesn't mean that it has not expired.
      return 'Expiry year is invalid';
    }

    if (!_hasDateExpired(month, year)) {
      return 'Card has expired';
    }
    return null;
  }

  /// With the card number with Luhn Algorithm
  /// https://en.wikipedia.org/wiki/Luhn_algorithm
  static String validateCardNum(String input) {
    if (input.isEmpty) {
      return 'Card Number is required';
    }

    input = CardUtils.getCleanedNumber(input);

    if (input.length < 8) {
      return 'Card is invalid';
    }

    int sum = 0;
    final int length = input.length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      int digit = int.parse(input[length - i - 1]);

      // every 2nd number multiply with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      return null;
    }

    return 'Card is invalid';
  }

  /// Convert the two-digit year to four-digit year if necessary
  static int _convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      final now = DateTime.now();
      final String currentYear = now.year.toString();
      final String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static bool _hasDateExpired(int month, int year) {
    return !(month == null || year == null) && _isNotExpired(year, month);
  }

  static bool _isNotExpired(int year, int month) {
    // It has not expired if both the year and date has not passed
    return !_hasYearPassed(year) && !_hasMonthPassed(year, month);
  }

  static bool _hasMonthPassed(int year, int month) {
    final now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is more than current month.
    return _hasYearPassed(year) ||
        _convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool _hasYearPassed(int year) {
    final int fourDigitsYear = _convertYearTo4Digits(year);
    final now = DateTime.now();
    // The year has passed if the year we are currently is more than card's
    // year
    return fourDigitsYear < now.year;
  }
}

abstract class StringValidator {
  bool isValid(String value);
}

class RegexValidator implements StringValidator {
  RegexValidator({this.regexSource});
  final String regexSource;

  @override
  bool isValid(String value) {
    try {
      // https://regex101.com/
      final RegExp regex = RegExp(regexSource);
      final Iterable<Match> matches = regex.allMatches(value);
      for (final Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

class ValidatorInputFormatter implements TextInputFormatter {
  ValidatorInputFormatter({this.editingValidator});
  final StringValidator editingValidator;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final bool oldValueValid = editingValidator.isValid(oldValue.text);
    final bool newValueValid = editingValidator.isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }
}

class EmailEditingRegexValidator extends RegexValidator {
  EmailEditingRegexValidator() : super(regexSource: '^(|\\S)+\$');
}

class EmailSubmitRegexValidator extends RegexValidator {
  EmailSubmitRegexValidator() : super(regexSource: '^\\S+@\\S+\\.\\S+\$');
}

class NonEmptyStringValidator extends StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class MinLengthStringValidator extends StringValidator {
  MinLengthStringValidator(this.minLength);
  final int minLength;

  @override
  bool isValid(String value) {
    return value.length >= minLength;
  }
}

class EmailAndPasswordValidators {
  final TextInputFormatter emailInputFormatter =
      ValidatorInputFormatter(editingValidator: EmailEditingRegexValidator());
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator =
      MinLengthStringValidator(8);
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();
}
