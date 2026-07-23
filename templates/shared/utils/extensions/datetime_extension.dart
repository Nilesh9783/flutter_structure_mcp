import 'package:intl/intl.dart' as dt;

extension DateTimeExtension on DateTime {
  // like this => wed, 4 jan 2023
  String get friendlyDateTime {
    dt.DateFormat df = dt.DateFormat('EE, d MMM yyyy');
    String dateString = df.format(this);
    return dateString;
  }

  String get mmYY {
    String dateString = dt.DateFormat.yMMMMd().format(this);
    return dateString;
  }

  String get mmDDYYYY {
    String dateString = dt.DateFormat('dd-MM-yyyy').format(this);
    return dateString;
  }

  // like this => 5min
  String get timeAgo {
    Duration diff = DateTime.now().difference(this);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()}y";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()}mo";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()}w";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays}d";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours}h";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes}m";
    }
    return "${1}m";
  }
}
