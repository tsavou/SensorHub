import 'package:sensor_hub/models/sensor.dart';

String formatTemperature(double value, {bool withUnit = true}) {
  final number = value.toStringAsFixed(1).replaceAll('.', ',');
  return withUnit ? '$number°C' : '$number°';
}

String formatPercent(num value) {
  if (value == value.roundToDouble()) {
    return '${value.round()} %';
  }
  return '${value.toStringAsFixed(1).replaceAll('.', ',')} %';
}

String formatDateTime(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$day/$month/${value.year} à $hour:$minute';
}

extension SensorDisplay on Sensor {
  String get detailTitle => 'Capteur : $name';

  String get cardStatusLabel {
    if (!isOnline) return 'Hors ligne';
    return switch (status) {
      SensorStatus.alert => 'Alerte',
      SensorStatus.ok => 'En ligne',
    };
  }

  String get connectionLabel => isOnline ? 'En ligne' : 'Hors ligne';

  String get etatLabel => switch (status) {
    SensorStatus.ok => 'OK',
    SensorStatus.alert => 'Alerte',
  };
}
