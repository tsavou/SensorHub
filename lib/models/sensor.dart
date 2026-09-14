import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensor.freezed.dart';
part 'sensor.g.dart';

enum SensorStatus { ok, alert }

@freezed
abstract class Sensor with _$Sensor {
  const factory Sensor({
    required String id,
    required String name,
    required double temperature,
    required double humidity,
    required int battery,
    required bool isOnline,
    required SensorStatus status,
    required DateTime lastMeasurement,
  }) = _Sensor;

  factory Sensor.fromJson(Map<String, dynamic> json) => _$SensorFromJson(json);
}
