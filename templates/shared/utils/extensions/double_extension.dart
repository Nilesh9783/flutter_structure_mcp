part of 'extension.dart';

extension WidgetExtension on double {
  Widget get widthSizedBox => SizedBox(width: this);
  Widget get heightSizedBox => SizedBox(height: this);

  String get currencyFormat {
    final format = NumberFormat("#,##,##0.00");
    return format.format(this);
  }

  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
