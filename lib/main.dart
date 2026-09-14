import 'package:flutter/cupertino.dart';
import 'package:sensor_hub/app_router.dart';
import 'package:sensor_hub/theme/app_theme.dart';

void main() {
  runApp(const SensorHubApp());
}

class SensorHubApp extends StatelessWidget {
  const SensorHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      title: 'SensorHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
    );
  }
}
