import 'dart:async';
import 'package:expense_tracker/reusable_component/loader/src/util/log_helper.dart';
import 'package:flutter/material.dart';

import 'dismiss_future.dart';
import 'loading.dart';
import 'theme.dart';

List<GlobalKey<LoadingProviderState>> _keys = [];

class LoadingProvider extends StatefulWidget {
  final Widget child;

  final LoadingThemeData themeData;

  // ignore: annotate_overrides, overridden_fields
  final GlobalKey<LoadingProviderState> key;

  final LoadingWidgetBuilder loadingWidgetBuilder;

  LoadingProvider({
    required this.child,
    required this.themeData,
    this.loadingWidgetBuilder = LoadingWidget.buildDefaultLoadingWidget,
    super.key,
  })  : key = createKey();

  @override
  LoadingProviderState createState() => LoadingProviderState();

  static GlobalKey<LoadingProviderState> createKey() {
    return GlobalKey();
  }
}

class LoadingProviderState extends State<LoadingProvider> {
  GlobalKey<OverlayState> overlayKey = GlobalKey();

  GlobalKey<LoadingWidgetState> loadingKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _keys.add(widget.key);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        key: overlayKey,
        initialEntries: [
          OverlayEntry(
            builder: (BuildContext context) {
              return widget.child;
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _keys.remove(widget.key);
    super.dispose();
  }

  LoadingDismissFuture showLoading({
    bool? tapDismiss,
  }) {
    tapDismiss ??= true;
    _realDismissDialog();
    var themeData = widget.themeData;
    var w = LoadingTheme(
      data: themeData.copyWith(
        tapDismiss: tapDismiss,
      ),
      child: LoadingWidget(
        key: loadingKey,
        loadingWidgetBuilder: widget.loadingWidgetBuilder,
      ),
    );
    var entry = OverlayEntry(builder: (BuildContext context) {
      return w;
    });

    overlayKey.currentState?.insert(entry);

    var future =
        LoadingDismissFuture(entry, loadingKey, themeData.animDuration);
    return future;
  }

  LoadingDismissFuture showLoadingWidget(
    Widget loadingWidget, {
    bool? tapDismiss,
  }) {
    _realDismissDialog();
    var themeData = widget.themeData;
    tapDismiss ??= themeData.tapDismiss;
    var w = LoadingTheme(
      data: themeData.copyWith(
        tapDismiss: tapDismiss,
      ),
      child: LoadingWidget(
        key: loadingKey,
        loadingWidgetBuilder: (_, __) => loadingWidget,
      ),
    );
    var entry = OverlayEntry(builder: (BuildContext context) {
      return w;
    });

    overlayKey.currentState?.insert(entry);

    var future =
        LoadingDismissFuture(entry, loadingKey, themeData.animDuration);
    return future;
  }

  void _realDismissDialog() {
    LoadLogHelper.log("native dismiss loading.");
    FutureManager.getInstance().dismissAll(false);
  }

  void dismissLoading() {
    LoadLogHelper.log("dismiss loading called.");
    _realDismissDialog();
  }
}

/// Use [LoadingDismissFuture.dismiss] can dismiss current dialog
Future<LoadingDismissFuture?> showLoadingDialog({
  bool? tapDismiss,
}) {
  LoadLogHelper.log("show loading dialog");
  var c = Completer<LoadingDismissFuture?>();
  Future.delayed(Duration.zero, () {
    if (_keys.isNotEmpty) {
      var key = _keys.first;
      c.complete(key.currentState?.showLoading(tapDismiss: tapDismiss));
    }
  });
  return c.future;
}

Future<LoadingDismissFuture> showCustomLoadingWidget(
  Widget widget, {
  bool? tapDismiss=false,
}) {
  LoadLogHelper.log("show custom loading dialog");
  var c = Completer<LoadingDismissFuture>();
  Future.delayed(Duration.zero, () {
    if (_keys.isNotEmpty) {
      var key = _keys.first;
      c.complete(key.currentState?.showLoadingWidget(
        widget,
        tapDismiss: tapDismiss,
      ));
    }
  });
  return c.future;
}

/// will dismiss all dialog
void hideLoadingDialog() {
  Future.delayed(Duration.zero, () {
    if (_keys.isNotEmpty) {
      var key = _keys.first;
      key.currentState?.loadingKey.currentState?.dismissAnim();
      key.currentState?.dismissLoading();
    }
  });
}
