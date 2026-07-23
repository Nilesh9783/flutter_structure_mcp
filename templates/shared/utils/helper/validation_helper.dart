import 'package:expense_tracker/utils/common/constants.dart';

class Validations {
  String? validateEmail(String value) {
    if (value.isEmpty) return 'Please Enter Email Address';
    final RegExp nameExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    if (!nameExp.hasMatch(value)) return 'Please Enter Valid Email Address';
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return 'Please choose a password.';
    final RegExp nameExp =
        RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$");
    if (!nameExp.hasMatch(value)) return 'Invalid password';
    return null;
  }

  String? validateEmpty({String? value, String? errorMessage}) {
    if (value == null || value.isEmpty) {
      return errorMessage ?? 'Please enter a value.';
    }
    return null;
  }

  String? validateAmount({String? value, String? errorMessage}) {
    if (value == null || value == "0") {
      return errorMessage ?? 'Please enter a value.';
    }
    value.replaceAll(",", "");
    final RegExp nameExp = RegExp(r'^[1-9]');
    if (!nameExp.hasMatch(value)) {
      return 'Please enter a valid amount';
    }
    return null;
  }

  String? validateBankAccountNumber({String? value, String? errorMessage}) {
    if (value == null) return errorMessage ?? 'Please enter a value.';
    final RegExp nameExp = RegExp(r'^[0-9]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Please enter a valid account number';
    }
    return null;
  }

  String? validateCardDateExpiry({String? value, String? errorMessage}) {
    if (value == null) return errorMessage ?? 'Please enter a value.';

    int mon = int.parse(value.split("/").first);
    int year = int.parse(value.split("/").last);
    int curryear = int.parse(DateTime.now().year.toString().substring(2, 4));
    int curMon = DateTime.now().month;
    if (mon >= 1 && mon <= 12) {
      if (curryear <= year) {
        if (curryear == year && mon < curMon) {
          return 'Please enter a valid card expiry date like: MM/YY';
        }
        return null;
      } else {
        return 'Please enter a valid card expiry date like: MM/YY';
      }
    } else {
      return 'Please enter a valid card expiry date like: MM/YY';
    }
  }

  String? validateCardNumber({String? value, String? errorMessage}) {
    if (value == null) {
      return errorMessage ?? 'Please enter a last 4 card Digit.';
    }
    final RegExp nameExp = RegExp(r'^[0-9]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Please enter a valid last 4 digit card number';
    }
    return null;
  }

  String? validateBankName({required String value}) {
    // ignore: unnecessary_null_comparison
    if (value == null) return 'Please enter a value.';
    final RegExp nameExp = RegExp(r'^[a-z A-Z,.\-]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Please enter only alphabetical characters.';
    }
    return null;
  }

  String? validateFName({required String value, bool isFirstName = true}) {
    if (value.isEmpty) {
      return isFirstName
          ? MsgConstants.enterFirstName
          : MsgConstants.enterLastName;
    } else {
      final RegExp nameExp = RegExp(r'^[a-z A-Z,.\-]+$');
      if (!nameExp.hasMatch(value)) {
        return 'Please enter only alphabetical characters.';
      } else {
        return null;
      }
    }
  }

  String? validateMobileNumber(String value) {
    if (value.isEmpty) {
      return MsgConstants.enterMobileNumber;
    } else {
      value = value.replaceAll("-", "");
      final RegExp nameExp = RegExp(r'(^(?:[+0]9)?[0-9]{9,15}$)');
      if (!nameExp.hasMatch(value)) {
        return 'Please enter valid mobile number';
      } else {
        return null;
      }
    }
  }

  String? validateOtp(String value) {
    if (value.isEmpty) {
      return MsgConstants.enterOtp;
    } else {
      if (value.length == 6) {
        return null;
      } else {
        return MsgConstants.enterValidateOtp;
      }
    }
  }

  String? validateDate(String value) {
    if (value.isEmpty) {
      return MsgConstants.endDate;
    } else {
      if (DateTime.now().compareTo(DateTime.parse(value)) < 0) {
        return MsgConstants.trsactionDate;
      }
      return null;
    }
  }
}

extension ListExtension on List {
  String arraytostring() {
    return toString().replaceAll("[", "").replaceAll("]", "");
  }
}
