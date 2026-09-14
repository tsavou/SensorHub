import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:sensor_hub/screens/dashboard_screen.dart';
import 'package:sensor_hub/screens/sensor_detail_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          CupertinoPage(key: state.pageKey, child: DashboardScreen()),
      routes: [
        GoRoute(
          path: 'sensors/:id',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return CupertinoPage(
              key: state.pageKey,
              child: SensorDetailScreen(sensorId: id),
            );
          },
        ),
      ],
    ),
  ],
);
