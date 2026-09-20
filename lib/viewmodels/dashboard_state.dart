import 'dart:collection';

import 'package:sensor_hub/models/sensor.dart';

/// État unique de l'écran dashboard. Hiérarchie fermée (`sealed`).
sealed class DashboardState {
  const DashboardState();
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardSuccess extends DashboardState {
  DashboardSuccess(List<Sensor> sensors)
    : sensors = UnmodifiableListView(sensors);

  final UnmodifiableListView<Sensor> sensors;

  int get offlineCount => sensors.where((sensor) => !sensor.isOnline).length;

  int get alertCount => sensors
      .where((sensor) => sensor.isOnline && sensor.status == SensorStatus.alert)
      .length;
}

final class DashboardError extends DashboardState {
  const DashboardError(this.message);

  final String message;
}
