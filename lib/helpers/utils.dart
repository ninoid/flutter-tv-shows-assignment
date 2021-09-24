import 'dart:math';


class Utils {

  Utils._();

  static bool isEmailAddresValid(String emailAddress) {
    final pattern =  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regex = new RegExp(pattern, caseSensitive: false);
    return regex.hasMatch(emailAddress);
  }


  static bool isPasswordByPasswordPolicyValid(String password) {
    /*
        r'^
        (?=.*[A-Z])       // should contain at least one upper case
        (?=.*[a-z])       // should contain at least one lower case
        (?=.*?[0-9])      // should contain at least one digit
        (?=.*?[!@#\$&*~_\.\,\?\-\+]).{8,}  // should contain at least one special character
        $
    */

    // with special characters
    // final pattern =  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_\.\,\?\-\+]).{8,}$';
    // without special characters
    final pattern =  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    final regex = new RegExp(pattern);
    return regex.hasMatch(password);
  }

  static bool isUrlValidRegexVersion(String url) {
    final urlPattern = r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
    final regex = new RegExp(urlPattern, caseSensitive: false);
    return regex.hasMatch(url);
  }

  static bool isUrlValidUriParseVersion(String url) {
    try {
      return Uri.parse(url).isAbsolute;
    } catch (e) {
      return false;
    }
  }

  static int randomNumber({int min = 0, int max = 9223372036854775807}) {
    final random = new Random();
    /**
     * Generates a positive random integer uniformly distributed on the range
     * from [min], inclusive, to [max], exclusive.
    */
    return min + random.nextInt(max - min);
  }

}

extension DoubleExtension on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension NumExtension on num {
  num positivise() => this < 0 ? -(this) : this;
}

extension DateUtils on DateTime {

  DateTime get date {
    return DateTime(this.year, this.month, this.day);
  }

  DateTime get endOfDay {
    return DateTime(this.year, this.month, this.day, 23, 59, 59, 999);
  }

  DateTime get firstDayOfMonth {
    return DateTime(this.year, this.month, 1);
  }

  DateTime get lastDayOfMonth {
    return DateTime(this.year, this.month + 1, 0);
  }

  DateTime get firstDayOfYear {
    return DateTime(this.year, 1, 1);
  }

  DateTime get lastDayOfYear {
    return DateTime(this.year, 12, 31);
  }

  bool isSameDate(DateTime other) {
    return  this.day == other.day &&
            this.month == other.month && 
            this.year == other.year;
  }

  bool get isToday {
    return this.isSameDate(DateTime.now());
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return this.isSameDate(yesterday);
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    return this.isSameDate(tomorrow);
  }
  
}