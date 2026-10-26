import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:sensor_hub/models/sensor.dart';
import 'package:sensor_hub/repositories/sensor_repository.dart';
import 'package:sensor_hub/utils/formatters.dart';
import 'package:sensor_hub/viewmodels/dashboard_state.dart';

class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel({
    required SensorRepository repository,
    this.staleAfter = defaultStaleAfter,
  }) : _repository = repository; // ignore: prefer_initializing_formals

  static const Duration defaultStaleAfter = Duration(seconds: 10);

  final SensorRepository _repository;
  final Duration staleAfter;

  DashboardState _state = const DashboardInitial();
  DateTime? _lastSuccessfulRefresh;
  List<Sensor> _lastSensors = const [];
  bool _isStale = false;
  Timer? _staleTimer;

  DashboardState get state => _state;

  DateTime? get lastSuccessfulRefresh => _lastSuccessfulRefresh;

  bool get isStale => _isStale;

  UnmodifiableListView<Sensor> get lastSensors =>
      UnmodifiableListView(_lastSensors);

  String get lastRefreshLabel {
    final refreshedAt = _lastSuccessfulRefresh;
    if (refreshedAt == null) {
      return 'Aucune actualisation réussie';
    }
    final label = 'Dernière actualisation réussie à ${formatTime(refreshedAt)}';
    if (_isStale) {
      return '$label · Données anciennes';
    }
    return label;
  }

  Future<void> load() async {
    if (_state is DashboardLoading) {
      return;
    }

    _setState(const DashboardLoading());

    try {
      final sensors = await _repository.getSensors();
      _lastSensors = List<Sensor>.of(sensors);
      _lastSuccessfulRefresh = DateTime.now();
      _isStale = false;
      _scheduleStaleCheck();
      _setState(DashboardSuccess(sensors));
    } on SensorRepositoryException catch (error) {
      _setState(DashboardError(error.message));
    } catch (_) {
      _setState(const DashboardError('Une erreur est survenue.'));
    }
  }

  void _scheduleStaleCheck() {
    _staleTimer?.cancel();
    _staleTimer = Timer(staleAfter, () {
      _isStale = true;
      notifyListeners();
    });
  }

  void _setState(DashboardState state) {
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _staleTimer?.cancel();
    super.dispose();
  }
}
