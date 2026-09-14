import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sensor_hub/models/sensor.dart';
import 'package:sensor_hub/utils/formatters.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({super.key, required this.sensor});

  final Sensor sensor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOffline = !sensor.isOnline;
    final isAlert = sensor.isOnline && sensor.status == SensorStatus.alert;

    final Color accent;
    if (isOffline) {
      accent = theme.colorScheme.outline;
    } else if (isAlert) {
      accent = theme.colorScheme.error;
    } else {
      accent = theme.colorScheme.primary;
    }

    return Opacity(
      opacity: isOffline ? 0.72 : 1,
      child: Card(
        elevation: 0,
        color: isOffline
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isOffline
                ? theme.colorScheme.outlineVariant
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/sensors/${sensor.id}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        sensor.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isOffline
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      formatTemperature(sensor.temperature, withUnit: false),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isOffline
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      formatPercent(sensor.humidity),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      sensor.cardStatusLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
