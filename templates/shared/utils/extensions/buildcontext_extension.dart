part of 'extension.dart';

extension ExtBuildContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;

  /// performs a simple [Navigator.pop] action and returns given [result]
  void navigateBack() => Navigator.pop(this);

  /// performs a simple [Navigator.push] action with given [route]
  void navigateTo(Widget screen) {
    Navigator.of(this).push(MaterialPageRoute<Widget>(builder: (_) => screen));
  }

  Future<void> navigatorBackWithParam({dynamic value}) async {
    Navigator.pop(this, value);
  }

  Future<dynamic> navigateToWithReturn(Widget screen,
      {bool isPrecent = false}) async {
    if (isPrecent) {
      final dynamic result =
          await Navigator.of(this).push(CupertinoPageRoute<dynamic>(
        fullscreenDialog: true,
        builder: (_) => screen,
        settings: RouteSettings(
          name: screen.toString(),
        ),
      ));
      return result;
    } else {
      final dynamic result = await Navigator.push(
        this,
        // Create the SelectionScreen in the next step.
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => screen,
            settings: RouteSettings(
              name: screen.toString(),
            ),
            fullscreenDialog: true),
      );

      return result;
    }
  }

  void present(Widget screen) {
    Navigator.of(this).push(CupertinoPageRoute<Widget>(
        fullscreenDialog: true, builder: (_) => screen));
  }

  /// performs a simple [Navigator.pushReplacement] action with given [route]
  void replaceWith(Widget screen) {
    Navigator.of(this).pushReplacement(MaterialPageRoute<Widget>(builder: (_) {
      return screen;
    }));
  }

  /// performs a simple [Navigator.pushAndRemoveUntil] action with given [route]
  void replaceAll(Widget screen) {
    Navigator.of(this).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen),
        (Route<dynamic> route) => false);
  }

  void showError(String message) {
    HapticFeedback.heavyImpact();
    MessageBar.error(message: message).show(this);
  }

  void showSucess(String message) {
    HapticFeedback.heavyImpact();
    MessageBar.success(message: message).show(this);
  }

  void showInfo(String message) {
    HapticFeedback.heavyImpact();
    MessageBar.information(message: message).show(this);
  }

  double getWidthWithSize({required double sizeConstant}) {
    return sizeConstant != 0.0
        ? ((MediaQuery.of(this).size.width * sizeConstant) / width)
        : 0.0;
  }

  double getScreenWidth() {
    return MediaQuery.of(this).size.width;
  }

  double getHeightWithSize({required double sizeConstant}) {
    return sizeConstant != 0.0
        ? ((MediaQuery.of(this).size.height * sizeConstant) /
            MediaQuery.of(this).size.height)
        : 0.0;
  }

  double getHeight() {
    return MediaQuery.of(this).size.height;
  }

  // void showLoaderDialog() {
  //   AlertDialog alert = AlertDialog(
  //     backgroundColor: Colors.transparent,
  //     elevation: 0,
  //     content: Center(
  //         child: CircularProgressIndicator(
  //       color: AppColors.c4483F7,
  //     )),
  //   );
  //   showDialog(
  //     barrierDismissible: false,
  //     context: this,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
}
