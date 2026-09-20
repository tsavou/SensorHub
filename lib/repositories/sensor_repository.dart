import 'package:sensor_hub/models/sensor.dart';

/// Contrat du Repository : uniquement ce dont le ViewModel a besoin.
abstract class SensorRepository {
  Future<List<Sensor>> getSensors();
}

class SensorRepositoryException implements Exception {
  const SensorRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
