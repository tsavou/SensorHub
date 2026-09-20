import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:sensor_hub/models/sensor.dart';
import 'package:sensor_hub/repositories/sensor_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel({required SensorRepository repository})
    : _repository = repository; // ignore: prefer_initializing_formals

  final SensorRepository _repository;

  List<Sensor> _sensors = [];
  bool _isLoading = false;
  String? _errorMessage;

  UnmodifiableListView<Sensor> get sensors => UnmodifiableListView(_sensors);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

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

  Future<void> load() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _sensors = await _repository.getSensors();
    } on SensorRepositoryException catch (error) {
      _sensors = [];
      _errorMessage = error.message;
    } catch (_) {
      _sensors = [];
      _errorMessage = 'Une erreur est survenue.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
