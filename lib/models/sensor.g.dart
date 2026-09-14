// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Sensor _$SensorFromJson(Map<String, dynamic> json) => _Sensor(
  id: json['id'] as String,
  name: json['name'] as String,
  temperature: (json['temperature'] as num).toDouble(),
  humidity: (json['humidity'] as num).toDouble(),
  battery: (json['battery'] as num).toInt(),
  isOnline: json['isOnline'] as bool,
  status: $enumDecode(_$SensorStatusEnumMap, json['status']),
  lastMeasurement: DateTime.parse(json['lastMeasurement'] as String),
);

Map<String, dynamic> _$SensorToJson(_Sensor instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'temperature': instance.temperature,
  'humidity': instance.humidity,
  'battery': instance.battery,
  'isOnline': instance.isOnline,
  'status': _$SensorStatusEnumMap[instance.status]!,
  'lastMeasurement': instance.lastMeasurement.toIso8601String(),
};

const _$SensorStatusEnumMap = {
  SensorStatus.ok: 'ok',
  SensorStatus.alert: 'alert',
};
