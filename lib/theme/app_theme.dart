import 'package:flutter/cupertino.dart';

abstract final class AppTheme {
  static const Color primary = Color(0xFF0F766E);

  static CupertinoThemeData light() {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
      barBackgroundColor: CupertinoColors.systemBackground,
    );
  }
}
