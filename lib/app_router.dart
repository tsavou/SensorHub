import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:sensor_hub/repositories/fake_sensor_repository.dart';
import 'package:sensor_hub/screens/dashboard_screen.dart';
import 'package:sensor_hub/screens/sensor_detail_screen.dart';
import 'package:sensor_hub/viewmodels/dashboard_view_model.dart';

final DashboardViewModel dashboardViewModel = DashboardViewModel(
  repository: FakeSensorRepository(),
);

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => CupertinoPage(
        key: state.pageKey,
        child: DashboardScreen(viewModel: dashboardViewModel),
      ),
      routes: [
        GoRoute(
          path: 'sensors/:id',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return CupertinoPage(
              key: state.pageKey,
              child: SensorDetailScreen(
                sensorId: id,
                viewModel: dashboardViewModel,
              ),
            );
          },
        ),
      ],
    ),
  ],
);
