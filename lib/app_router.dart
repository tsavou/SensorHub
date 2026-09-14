import 'package:go_router/go_router.dart';
import 'package:sensor_hub/screens/dashboard_screen.dart';
import 'package:sensor_hub/screens/sensor_detail_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => DashboardScreen()),
    GoRoute(
      path: '/sensors/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return SensorDetailScreen(sensorId: id);
      },
    ),
  ],
);
