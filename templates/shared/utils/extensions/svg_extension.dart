part of 'extension.dart';

///
/// Extension Method for the [SVG] Widget
///
extension SVGIcons on String {
  Widget svgAssetImage(
          {double? width,
          double? height,
          Color? color,
          BoxFit fit = BoxFit.contain,
          Alignment alignment = Alignment.center}) =>
      SvgPicture.asset(
        this,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        // ignore: deprecated_member_use
        color: color,
      );
}
