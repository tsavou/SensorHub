import 'package:flutter/foundation.dart';
import 'package:sensor_hub/models/sensor.dart';
import 'package:sensor_hub/repositories/sensor_repository.dart';
import 'package:sensor_hub/viewmodels/dashboard_state.dart';

class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel({required SensorRepository repository})
    : _repository = repository; // ignore: prefer_initializing_formals

  final SensorRepository _repository;

  DashboardState _state = const DashboardInitial();

  DashboardState get state => _state;

  Sensor? findById(String id) {
    final current = _state;
    if (current is! DashboardSuccess) {
      return null;
    }
    for (final sensor in current.sensors) {
      if (sensor.id == id) {
        return sensor;
      }
    }
    return null;
  }

  Future<void> load() async {
    if (_state is DashboardLoading) {
      return;
    }

    _setState(const DashboardLoading());

    try {
      final sensors = await _repository.getSensors();
      _setState(DashboardSuccess(sensors));
    } on SensorRepositoryException catch (error) {
      _setState(DashboardError(error.message));
    } catch (_) {
      _setState(const DashboardError('Une erreur est survenue.'));
    }
  }

  void _setState(DashboardState state) {
    _state = state;
    notifyListeners();
  }
}
