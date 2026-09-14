import 'dart:collection';

import 'package:sensor_hub/models/sensor.dart';

class DashboardViewModel {
  DashboardViewModel() : _sensors = _createMockSensors();

  final List<Sensor> _sensors;

  UnmodifiableListView<Sensor> get sensors => UnmodifiableListView(_sensors);

  int get offlineCount => _sensors.where((sensor) => !sensor.isOnline).length;

  int get alertCount => _sensors
      .where((sensor) => sensor.isOnline && sensor.status == SensorStatus.alert)
      .length;

  Sensor? findById(String id) {
    for (final sensor in _sensors) {
      if (sensor.id == id) {
        return sensor;
      }
    }
    return null;
  }

  static List<Sensor> _createMockSensors() {
    return [
      Sensor(
        id: 'salon',
        name: 'Salon',
        temperature: 21.8,
        humidity: 45,
        battery: 82,
        isOnline: true,
        status: SensorStatus.ok,
        lastMeasurement: DateTime(2026, 9, 14, 13, 5),
      ),
      Sensor(
        id: 'garage',
        name: 'Garage',
        temperature: 29.6,
        humidity: 61,
        battery: 47,
        isOnline: true,
        status: SensorStatus.alert,
        lastMeasurement: DateTime(2026, 9, 14, 12, 58),
      ),
      Sensor(
        id: 'cave',
        name: 'Cave',
        temperature: 12.4,
        humidity: 78,
        battery: 18,
        isOnline: false,
        status: SensorStatus.ok,
        lastMeasurement: DateTime(2026, 9, 13, 8, 12),
      ),
    ];
  }
}
