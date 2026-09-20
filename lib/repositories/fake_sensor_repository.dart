import 'package:sensor_hub/models/sensor.dart';
import 'package:sensor_hub/repositories/sensor_repository.dart';

/// Source simulée : données, latence et erreur, sans HTTP ni base.
class FakeSensorRepository implements SensorRepository {
  FakeSensorRepository({
    this.delay = defaultDelay,
    this.shouldFail = false,
    List<Sensor>? sensors,
  }) : _sensors = List<Sensor>.unmodifiable(sensors ?? _defaultSensors);

  static const Duration defaultDelay = Duration(milliseconds: 3000);

  final Duration delay;
  final bool shouldFail;
  final List<Sensor> _sensors;

  @override
  Future<List<Sensor>> getSensors() async {
    await Future<void>.delayed(delay);
    if (shouldFail) {
      throw const SensorRepositoryException(
        'Impossible de charger les capteurs.',
      );
    }
    return _sensors;
  }

  static final List<Sensor> _defaultSensors = [
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
