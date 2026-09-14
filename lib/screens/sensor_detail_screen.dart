import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sensor_hub/data/mock_sensors.dart';
import 'package:sensor_hub/models/sensor.dart';
import 'package:sensor_hub/utils/formatters.dart';

class SensorDetailScreen extends StatelessWidget {
  const SensorDetailScreen({super.key, required this.sensorId});

  final String sensorId;

  @override
  Widget build(BuildContext context) {
    final sensor = findSensorById(sensorId);
    if (sensor == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _goBack(context),
          ),
          title: const Text('Capteur introuvable'),
        ),
        body: const Center(
          child: Text('Aucun capteur ne correspond à cet identifiant.'),
        ),
      );
    }

    return _SensorDetailBody(sensor: sensor);
  }

  static void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }
}

class _SensorDetailBody extends StatelessWidget {
  const _SensorDetailBody({required this.sensor});

  final Sensor sensor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOffline = !sensor.isOnline;
    final connectionColor = isOffline
        ? theme.colorScheme.outline
        : theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => SensorDetailScreen._goBack(context),
        ),
        title: Text(sensor.detailTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: connectionColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  sensor.connectionLabel,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: connectionColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _MetricRow(
              label: 'Température',
              value: formatTemperature(sensor.temperature),
            ),
            _MetricRow(
              label: 'Humidité',
              value: formatPercent(sensor.humidity),
            ),
            _MetricRow(label: 'Batterie', value: formatPercent(sensor.battery)),
            const SizedBox(height: 24),
            _MetricRow(label: 'État', value: sensor.etatLabel),
            const SizedBox(height: 32),
            Text('Dernière mesure', style: theme.textTheme.titleSmall),
            const SizedBox(height: 6),
            Text(
              formatDateTime(sensor.lastMeasurement),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
